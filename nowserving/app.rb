require 'sinatra/base'

class NowServing < Sinatra::Base
  set server: :thin, connections: []
  set :protection, :except => :frame_options

  get '/' do
    erb :index
  end

  get '/ctrl' do
    erb :ctrl
  end

  get '/stream', :provides => 'text/event-stream' do
    stream :keep_open do |out|
      settings.connections << out
      out.callback {settings.connections.delete(out)}
    end
  end

  post '/count' do
    settings.connections.each {|out| out << "data: #{params[:msg]}\n\n"}
    204
  end
end
