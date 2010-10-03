require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'chart'))
require 'json'
require 'base64'

class KnittingApp < Sinatra::Base
  configure :production do
      ENV['APP_ROOT'] ||= File.dirname(__FILE__)
      $:.unshift "#{ENV['APP_ROOT']}/vendor/plugins/newrelic_rpm/lib"
      require 'newrelic_rpm'
  end

  set :reload, true
  set :public, "public"

  get '/' do
    haml :index
  end

  get '/style.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :style
  end
  
  get '/chart.json' do
    instructions = params[:instructions].split(/\n/)
    hashtag = Base64.encode64 params[:instructions]

    { :chart => Chart.from_instructions(instructions).to_text,
      :hashtag => hashtag.strip }.to_json
  end

  get '/chart/load.json' do
    encoded = params[:encoded]
    { :instructions => Base64.decode64(encoded) }.to_json
  end
end
