require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'chart'))
require 'json'

class KnittingApp < Sinatra::Base
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
    instructions = params[:instructions]
    Chart.from_instructions(instructions).to_text.to_json
  end
end