require 'sinatra/base'

class NowServing < Sinatra::Base
  set server: :thin, connections: []
  set :protection, :except => :frame_options
  configure do
    @@counter = 0
  end

  get '/' do
    puts '->' + @@counter.to_s
    @counter = @@counter
    erb :index
  end

  get '/ctrl' do
    puts '=>' + @@counter.to_s
    @counter = @@counter
    erb :ctrl
  end

  get '/stream', :provides => 'text/event-stream' do
    stream :keep_open do |out|
      settings.connections << out
      out.callback {settings.connections.delete(out)}
    end
  end

  post '/count' do
    @@counter = params[:msg].to_i
    puts ">>" + @@counter.to_s
    settings.connections.each {|out| out << "data: #{params[:msg]}\n\n"}
    204
  end
end
