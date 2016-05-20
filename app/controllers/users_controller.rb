class UsersController < ApplicationController
  def index
    render :json => User.all
  end

  def anmelden
    @user = User.find_by(login: params[:login])
    if @user.nil?
      render nothing: true , status: 404
    else
    render json: @user.to_json(only: %w(login salt_masterkey pubkey_user privkey_user_enc))
    end
  end

  def pubkey
    @user = User.find_by(login: params[:login])
    if @user.nil?
      render nothing: true , status: 404
    else
      render json: @user.to_json(only: %w(login pubkey_user))
    end
  end

  def create
    @user = User.new(login: params[:login])

      if @user.save
        render json: @user
      else
        render nothing: true , status: 404
      end
  end
end
