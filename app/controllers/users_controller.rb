class UsersController < ApplicationController
  def index
    render :json => User.all
  end

  def show
    @user = User.find_by(login: params[:login])
    if @user.nil?
      render json: 'User unbekannt'
    else
    render json: @user.to_json(only: %w(login salt_masterkey pubkey_user privkey_user_enc))
    end
  end
end
