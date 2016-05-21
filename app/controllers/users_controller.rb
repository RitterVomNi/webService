class UsersController < ApplicationController
  def index
    render :json => User.all.to_json(only: %w(salt_masterkey login privkey_user_enc))
  end

  def anmelden
    @user = User.find_by(login: params[:login])
    if @user.nil?
      render nothing: true , status: 404
    else
    render json: @user.to_json(only: %w(salt_masterkey privkey_user_enc pubkey_user))
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
    @user = User.new(login: params[:login], salt_masterkey: params[:salt_masterkey], pubkey_user: params[:pubkey_user], privkey_user_enc: params[:privkey_user_enc])

      if @user.save
        render json: @user.to_json(only: %w(login))
      else
        render nothing: true , status: 404
      end
  end
end
