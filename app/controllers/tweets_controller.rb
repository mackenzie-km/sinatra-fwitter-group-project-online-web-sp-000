class TweetsController < ApplicationController
  get '/tweets' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'tweets/index'
    else
      redirect "/login"
    end
  end


  get '/tweets/new' do
    if logged_in?
      erb :'/tweets/new'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if logged_in? && params[:content] != ""
      @tweet = Tweet.create(content: params[:content], user_id: session[:user_id])
      erb :'tweets/show'
    elsif logged_in? && params[:content] == ""
      redirect '/tweets/new'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :'tweets/show'
    else
      redirect '/login'
    end
  end

    get '/tweets/:id/edit' do
      @tweet = Tweet.find(params[:id])
      binding.pry
      if !logged_in?
        redirect '/login'
      elsif logged_in? && (session[:user_id] == @tweet.user.id)
        erb :'tweets/edit'
      else
        redirect '/tweets'
      end
    end

    patch '/tweets/:id' do
      if !logged_in?
        redirect '/login'
      elsif logged_in? && (params[:content] != "")
        @tweet = Tweet.find(params[:id])
        @tweet.content = params[:content]
        @tweet.save
        erb :'tweets/show'
      else
        redirect "/tweets/#{params[:id]}/edit"
      end
    end

  post '/tweets/delete' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      @tweet.delete
    else
      redirect '/login'
    end
  end

end
