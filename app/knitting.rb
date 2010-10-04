require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'chart'))
require 'json'
require 'base64'
require 'haml'
require 'sass'
require 'url_shortener'
require 'uri'


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

  get '/shorten.json' do
    hashtag = params[:hashtag].gsub(/[\n]/, '')
    escaped = URI.escape hashtag, '='
    authorize = UrlShortener::Authorize.new 'michaelmelanson', 'R_680c1476bc6717774d120f45d908f5d8'

    url = 'http://knitting.heroku.com/#hashtag=' + escaped

    client = UrlShortener::Client.new authorize
    shorten = client.shorten(url)

    cache_control :public, :max_age => 0
    { :url => shorten.urls }.to_json
  end

  get '/chart/load.json' do
    encoded = params[:encoded]
    instructions = Base64.decode64(encoded) rescue ""

    cache_control :public, :max_age => 1.year
    { :instructions => instructions }.to_json
  end
end
