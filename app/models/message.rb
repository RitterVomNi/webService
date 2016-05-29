class Message < ActiveRecord::Base
  #1:n Beziehung mit User
  belongs_to :user

  # Überprüft die digitale Signatur mit dem pubkey des Senders
  def self.check_sig(timestamp, login, digitale_signatur)

    user = User.find_by(login: login)
    pubkey = user.pubkey_user


    pubkey_user = OpenSSL::PKey::RSA.new(pubkey)

    check = false
    check2 = false
    begin
      pubkey_user.public_decrypt(Base64.decode64(digitale_signatur))
      check = true
    rescue
    end

    if Time.zone.now.to_i - timestamp.to_i < 300
      check2 = true
    end

    return "" unless check and check2


    # Model gibt den User an den Controller zurück
    return user
  end

end
