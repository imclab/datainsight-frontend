require "bundler"
Bundler.require

require 'sinatra/content_for'

require_relative "../config/initializers/asset_host" if File.exists?(File.dirname(__FILE__) + '/../config/initializers/asset_host.rb')
require_relative "config"
require_relative "sprocket_env"
require_relative "helpers"
require_relative "api"

unless defined?(USE_STUB_DATA)
  USE_STUB_DATA = false
end

class App < Sinatra::Base
  helpers Padrino::Helpers
  helpers Sinatra::ContentFor
  helpers Insight::Helpers

  configure do
    set :public_folder, File.expand_path(File.dirname(__FILE__) + "/../public")
    set :uri_root, '/performance'
    if defined?(ASSET_HOST)
      set :asset_host, ASSET_HOST
    else
      set :asset_host, production? ? (Plek.current.find("cdn") + "/datainsight-frontend") : settings.uri_root
    end
    set :asset_dir, 'public/datainsight-frontend/assets'
    set :asset_path, '/assets'
    set :sprocket_env, SprocketEnvHolder.instance.environment
    set :graphs_images_dir, "/var/tmp/graphs"
    # JSON CSRF is only relevant, if you have non-public data of editing something
    # http://flask.pocoo.org/docs/security/#json-security
    set :protection, :except => :json_csrf
  end

  def api_urls
    settings.api_urls
  end

  def asset_host
    settings.asset_host
  end

  def api_result_to_json(result)
    result == :error ? 500 : result.to_json
  end

  def self.serve_graph_image(image_filename)
    get "/graphs/#{image_filename}" do
      content_type "image/png"
      headers['X-Slimmer-Skip'] = "true"
      send_file "#{settings.graphs_images_dir}/#{image_filename}"
    end
  end

  get "/" do
    erb :index, :locals => {:page => 'index'}
  end

  get "/dashboard" do
    @narrative = api(api_urls).narrative
    @trust = api(api_urls).user_trust

    erb :engagement
  end

  get "/narrative" do
    @narrative = api(api_urls).narrative
    erb :narrative
  end

  get "/graphs/visits.json" do
    content_type :json
    api_result_to_json(api(api_urls).weekly_visits)
  end

  get "/visits" do
    erb :visits
  end

  serve_graph_image "visits.png"

  get "/graphs/unique-visitors.json" do
    content_type :json
    api_result_to_json(api(api_urls).weekly_visitors)
  end

  get "/unique-visitors" do
    erb :unique_visitors
  end

  serve_graph_image "unique-visitors.png"

  get "/graphs/trust.json" do
    content_type :json
    api(api_urls).user_trust.to_json
  end

  get "/trust" do
    @trust = api(api_urls).user_trust

    erb :trust
  end

  get "/graphs/todays-activity.json" do
    content_type :json
    api_result_to_json(api(api_urls).todays_activity)
  end

  get "/todays-activity" do
    erb :todays_activity
  end

  serve_graph_image "todays-activity.png"

  error do
    logger.error env['sinatra.error']

    erb :error
  end

  get "/format-success" do
    erb :format_success
  end

  serve_graph_image "format-success.png"

  get "/graphs/format-success.json" do
    content_type :json
    api_result_to_json(api(api_urls).format_success)
  end
end
