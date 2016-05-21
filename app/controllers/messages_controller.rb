class MessagesController < ApplicationController
  def abholen
    @user = User.find_by(login: params[:login])
    render json: @user.messages
  end

  def create
    recipient = User.find_by(login: params[:recipient]).id
    content_enc = Base64.encode64(params[:content_enc])
    sig_recipient = Base64.encode64(params[:sig_recipient])
    sig_service = Base64.encode64(params[:sig_service])
    key_recipient_enc = Base64.encode64(params[:key_recipient_enc])

    msg = Message.new(recipient: recipient, content_enc: content_enc, sender: params[:sender],
                      iv: params[:iv], key_recipient_enc: key_recipient_enc, sig_recipient: sig_recipient,
                      sig_service: sig_service)

    if msg.save
      render nothing: true , status: 200
    else
      render nothing: true , status: 404
    end
  end
end
