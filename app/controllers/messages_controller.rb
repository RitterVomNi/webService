class MessagesController < ApplicationController
  def abholen
    @user = User.find_by(login: params[:login])
    render json: @user.messages
  end
end
