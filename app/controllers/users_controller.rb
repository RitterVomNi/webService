class UsersController < ApplicationController

  def anmelden
    @user = User.find_by(login: params[:login])

    head 400 unless @user != nil
    
    render json: @user.to_json(only: %w(salt_masterkey privkey_user_enc pubkey_user))

  end

  def pubkey
    @user = User.find_by(login: params[:login])
    if @user.nil?
      head 404
    else
      render json: @user.to_json(only: %w(pubkey_user))
    end
  end

  def create
    @user = User.new(login: params[:login], salt_masterkey: params[:salt_masterkey], pubkey_user: params[:pubkey_user], privkey_user_enc: params[:privkey_user_enc])

      if @user.save
        render nothing: true , status: 201
      else
        render nothing: true , status: 400
      end
  end

  def destroy
    user = User.find_by(login: params[:login])
    user.destroy

    render nothing: true ,  status: 200
  end

end
