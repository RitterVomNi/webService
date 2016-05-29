class MessagesController < ApplicationController

  def letzte_abholen

    # Überprüfen der Signatur an das Model message.rb deligiert => DRY
    user = Message.check_sig(params[:timestamp].to_s, params[:login], params[:digitale_signatur])

    if user == ""
      head 404
    else
      # Gibt die letzte Nachricht im JSON Format an den Client zurück
      render json: user.messages.last.to_json(only: %w(sender content_enc iv key_recipient_enc sig_recipient id created_at))
    end


  end

  def alle_abholen

    # Überprüfen der Signatur an das Model message.rb deligiert => DRY
    user = Message.check_sig(params[:timestamp].to_s, params[:login], params[:digitale_signatur])

    if user == ""
      head 404
    else
    # Gibt alle Nachrichten, beginnend mit der neuesten, im JSON Format an den Client zurück
    render json: user.messages.order('created_at desc').to_json(only: %w(sender content_enc iv key_recipient_enc sig_recipient id created_at))
    end
  end

  def create


    # Generate pubkey_user from DB
    pub_key_sender = User.find_by(login: params[:sender]).pubkey_user
    pubkey_user = OpenSSL::PKey::RSA.new(pub_key_sender)


    # Failsafe Default - return 404 wenn nicht richtiger pubkey zum entschlüsseln von sig_service und erlaubter timestamp
    check = false
    check2 = false

    begin

      # Wenn sig_service mit dem public key entschlüsselt werden kann, dann ist der erste check erfolgreich
      pubkey_user.public_decrypt(Base64.decode64(params[:sig_service]))
      check = true
      # Exception abfangen falls pubkey nicht zu sig_service passt
    rescue
    end

    # Wenn aktueller timestamp und gesendeter timestamp weniger als 5 Minuten auseinander liegen, dann ist der zweite check erfolgreich
    if Time.zone.now.to_i - params[:timestamp].to_i < 300
      check2 = true
    end

    return head 404 unless check and check2

    recipient = User.find_by(login: params[:recipient]).id

    # Erstellen der Nachricht
    msg = Message.new(recipient: recipient, content_enc: params[:content_enc], sender: params[:sender],
                      iv: params[:iv], key_recipient_enc: params[:key_recipient_enc], sig_recipient: params[:sig_recipient],
                      sig_service: params[:sig_service])

    # Persistieren der Nachricht in der DB
    if msg.save
      render nothing: true , status: 201
    else
      render nothing: true , status: 404
    end

  end

  # Einzelne Nachricht finden und löschen
  def destroy_single

    user = Message.check_sig(params[:timestamp].to_s, params[:login], params[:digitale_signatur])

    if user == ""
      head 404
    else
    message = Message.find_by(id: params[:id])
    message.destroy

    render nothing: true ,  status: 200
      end
  end

  # Alle Nachrichten eines Users finden und löschen
  def destroy_all

    user = Message.check_sig(params[:timestamp].to_s, params[:login], params[:digitale_signatur])

    if user == ""
      head 404
    else
    messages = user.messages
    messages.destroy_all

    render nothing: true ,  status: 200
      end
  end

end
