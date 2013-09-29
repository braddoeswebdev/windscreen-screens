require 'sinatra/base'

class AdRotatorScreen < Sinatra::Base
    set server: :thin, connections: []
    set :protection, :except => :frame_options

    configure do
        @@counter = 0
    end

    get '/' do
        @current = @@counter
        txt = File.read(File.join('adrotate', 'data', 'ads.txt'))
        @ads = txt.split("\n").delete_if{|l| l[0] == '#'}
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

    post '/post' do
        if params[:ctr]
            @@counter = params[:ctr].to_i
            puts "Updated counter to #{@@counter}"
        else
            settings.connections.each {|out| out << "data: #{params[:msg]}\n\n"}
        end
        204
    end
end
