require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'

class Chitter < Sinatra::Base

  env = ENV['RACK_ENV'] || 'development'

  DataMapper.setup(:default, "postgres://localhost/chitter_#{env}")

  require './lib/post.rb'
  require './lib/tag.rb'
  require './lib/user.rb'

  DataMapper.finalize

  DataMapper.auto_upgrade!

  enable :sessions
  set :session_secret, 'super secret'

  use Rack::Flash
  use Rack::MethodOverride

  get '/' do
    @posts = Post.all
    erb :index
  end

  post '/posts' do 
    message = params['message']
    tags = params["tags"].split(",").map do |tag|
      Tag.first_or_create(text: tag)
    end
    Post.create(message: message, tags: tags)
    redirect to('/')
  end 

  get '/users/new' do
    @user = User.new
    erb :"users/new"
  end

  post '/users' do 
    @user = User.create(email: params[:email],
                username: params[:username],
                name: params[:name],
                password: params[:password],
                password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :"users/new"
    end
  end

  get '/sessions/new' do
    erb :"sessions/new"
  end

  post '/sessions' do
    username, password = params[:username], params[:password]
    user = User.authenticate(username, password)
    if user
      session[:user_id] = user.id
      redirect to('/')
    else
      flash.now[:errors] = ["The username or password is incorrect"]
      erb :"sessions/new"
    end
  end

  delete '/sessions' do
    flash[:notice] = 'Good bye!'
    session[:user_id] = nil
    redirect to('/')
  end

  helpers do

    def current_user
      @current_user ||=User.get(session[:user_id]) if session[:user_id]
    end

  end
  # start the server if ruby file executed directly
  run! if app_file == $0
end
