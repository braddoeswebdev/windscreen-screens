require 'rubygems'
require 'sinatra'

Dir['./*/app.rb'].each {|f| require f}

disable :run
set :environment, :development

map '/nowserving' do
  run NowServing
end

map '/template' do
  run WindscreenTemplate
end

map '/img' do
  run StaticImageScreen
end
