class MessagesController < ApplicationController
  def abholen

    iu = OpenSSL::Digest::SHA256.new
    iu << params[:timestamp].to_s
    iu << params[:login]
    dig_sig = iu.digest

    # Failsafe Default - return 404, falls die digitale Signatur des request inkorrekt
   return head 404 unless params[:digitale_signatur] == Base64.encode64(dig_sig)

    @user = User.find_by(login: params[:login])
    render json: @user.messages.last.to_json(only: %w(sender content_enc iv key_recipient_enc sig_recipient))
  end

  def create

    # Generate pubkey_user from DB
    pub_key_sender = User.find_by(login: params[:sender]).pubkey_user
    pubkey_user = OpenSSL::PKey::RSA.new(pub_key_sender)


    # Failsafe Default - return 404 wenn nicht richtiger pubkey zum entschlüsseln von sig_service und erlaubter timestamp
    check = false
    begin
      pubkey_user.public_decrypt(Base64.decode64(params[:sig_service]))
      check = true
      rescue
    end
    check2 = false
    if Time.now.to_i - params[:timestamp].to_i < 300
      check2 = true
    end
    return head 404 unless check and check2

    recipient = User.find_by(login: params[:recipient]).id

    msg = Message.new(recipient: recipient, content_enc: params[:content_enc], sender: params[:sender],
                      iv: params[:iv], key_recipient_enc: params[:key_recipient_enc], sig_recipient: params[:sig_recipient],
                      sig_service: params[:sig_service])

    if msg.save
      render nothing: true , status: 201
    else
      render nothing: true , status: 404
    end

  end
end
