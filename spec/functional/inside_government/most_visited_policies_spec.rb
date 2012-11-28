require "functional/test_helper"

def most_visited_policies_body(overrides)
  policy_visits_entity = {
      "response_info" => {
          "status" => "ok"
      },
      "id" => "https://www.gov.uk/performance/dashboard/visits.json",
      "web_url" => "https://www.gov.uk/performance/dashboard/visits",
      "details" => {
          "source" => ["Google Analytics", "Celebrus", "Omniture"],
          "start_at" => "2012-05-20",
          "end_at" => "2012-06-03",
          "data" => []
      },
      "updated_at" => "2012-11-26T16:00:07+00:00"
  }

  policy_defaults = {
      "policy" => {
          "title" => "Default policy title",
          "department" => "ZZZ",
          "updated_at" => "2000-01-01T12:00:00+00:00",
          "web_url" => "https://www.gov.uk/default_policy_url"
      },
      "visits" => 0
  }

  overrides.each do |policy_data|
    policy_visits_entity["details"]["data"] << policy_defaults.deep_merge(policy_data)
  end

  policy_visits_entity.to_json
end

def serve_most_visited_policies(policy_data)
  FakeWeb.register_uri(
      :get,
      "#{Settings.api_urls['inside_government_base_url']}/most-visited-policies",
      :body => most_visited_policies_body(policy_data))
end


describe "Most Visited Policies" do

  before :each do
    serve_most_visited_policies([
        {
            "policy" => {
                "title" => "Most visited policy",
                "department" => "ABC",
                "updated_at" => "2012-11-25T16:00:07+00:00",
                "web_url"=>"https://www.gov.uk/most_visited_policy"
            },
            "visits" => 567000
        },
        {"policy" => {"title" => "Second most visited policy"}},
        {"policy" => {"title" => "#3 most visited policy"}},
        {"policy" => {"title" => "#4 most visited policy"}},
        {"policy" => {"title" => "#5 most visited policy"}}
    ])
  end

  it "should show most visited policies" do
    visit "/performance/dev/inside-government"

    page.find("#most-visited-policies-module h2").text.should == "Top policies last week"
  end

  it "should show 5 most visited policies" do
    visit "/performance/dev/inside-government"

    page.all("#most-visited-policies-module .policy").count.should == 5

    page.all("#most-visited-policies-module .policy-title").first.should have_link("Most visited policy", href: "https://www.gov.uk/most_visited_policy")
    page.all("#most-visited-policies-module .policy-department").first.text.should == "ABC"
    page.all("#most-visited-policies-module .policy-updated-at").first.text.should == "Updated 25 November 2012"
    page.all("#most-visited-policies-module .policy-visits").first.text.should == "567k"

    page.all("#most-visited-policies-module .policy-title").second.should have_link "Second most visited policy"

    page.all("#most-visited-policies-module .policy-title")[2].should have_link "#3 most visited policy"
    page.all("#most-visited-policies-module .policy-title")[3].should have_link "#4 most visited policy"
    page.all("#most-visited-policies-module .policy-title")[4].should have_link "#5 most visited policy"
  end

end
