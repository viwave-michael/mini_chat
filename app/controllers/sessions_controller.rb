class SessionsController < ApplicationController
  def create
    # render text: request.env['omniauth.auth'].to_yaml
    
    user = User.from_omniauth(request.env['omniauth.auth'])
    cookies[:user_id] = user.id
    flash[:success] = "Hello, #{user.name}!"
    redirect_to root_url
  end

  def destroy
    cookies.delete(:user_id)
    flash[:success] = "See you!"
    redirect_to root_url
  end

  def auth_fail
    render text: "You've tried to authenticate via #{params[:strategy]}, but the following error occurred: #{params[:message]}"
  end

  def sign_in
    p params
    user = User.find_by(uid: params[:user_id])
    cookies[:user_id] = user.id
    flash[:success] = "Hello, #{user.name}!"
    redirect_to root_url
  end
end
