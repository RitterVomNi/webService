class MessagesController < ApplicationController
  def show
    @user = User.find_by(login: params[:login])
    render json: @user.messages
  end
end
