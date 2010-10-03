require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'chart'))
require 'json'
require 'base64'
require 'haml'
require 'sass'

class Fixnum
  def minutes
    self * 60
  end
  def hours
    (self * 60).minutes
  end
  def days
    (self * 24).hours
  end
  def year
    (self * 365).days
  end
end

class KnittingApp < Sinatra::Base
  configure :production do
      ENV['APP_ROOT'] ||= File.dirname(__FILE__)
      $:.unshift "#{ENV['APP_ROOT']}/vendor/plugins/newrelic_rpm/lib"
      require 'newrelic_rpm'
  end

  helpers do
    def link_to(url, text)
      "<a href=\"#{url}\">#{text}</a>"
    end
  end

  set :reload, true
  set :public, "public"

  get '/' do
    cache_control :public, :max_age => 1.days
    haml :index
  end

  get '/style.css' do
    cache_control :public, :max_age => 6.hours
    content_type 'text/css', :charset => 'utf-8'
    sass :style
  end
  
  get '/chart.json' do
    instructions = params[:instructions].strip.split(/[\r\n]+/)
    hashtag = Base64.encode64 params[:instructions]
    puts "instructions: #{instructions}"
    if instructions.empty?
      chart = [""]
    else
      chart = Chart.from_instructions(instructions).to_text
    end

    puts "chart: #{chart}"

    cache_control :public, :max_age => 1.year
    { :chart => chart,
      :hashtag => hashtag.strip }.to_json
  end

  get '/chart/load.json' do
    encoded = params[:encoded]

    cache_control :public, :max_age => 1.year
    { :instructions => Base64.decode64(encoded) }.to_json
  end
end
