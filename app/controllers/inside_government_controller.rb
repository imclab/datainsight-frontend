class InsideGovernmentController < ApplicationController

  def index
    json = api.most_visited_policies
    @policies = PolicyVisits.build(json)
  rescue Exception
    @policies = nil
  end

  def visitors_weekly
    serve_json do
      json = api.inside_gov_weekly_visitors
      json["id"] = url_for :controller => "inside_government", :action => "visitors_weekly", :format => :json
      json["web_url"] = url_for :controller => "inside_government", :action => "index"
      json
    end
  end

  def format_success
    serve_json do
      json = api.inside_gov_format_success
      json["id"] = url_for :controller => 'inside_government', :action => 'format_success', :format => :json
      json["web_url"] = url_for :controller => 'inside_government', :action => 'index', :anchor => "format-success-module"
      json
    end
  end

  def most_visited_policies
    serve_json do
      json = api.most_visited_policies
      json["id"] = url_for :controller => 'inside_government', :action => 'most_visited_policies', :format => :json
      json["web_url"] = url_for :controller => 'inside_government', :action => 'index', :anchor => "most-visited-policies-module"
      json
    end
  end

end
