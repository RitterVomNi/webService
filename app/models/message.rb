class Message < ActiveRecord::Base
  #1:n Beziehung mit User
  belongs_to :user

  # Bildet eine digitale Signatur über login und timestamp und vergleicht diese mit der vom Client übergebenen Signatur
  def self.sha256_gen(timestamp, login, digitale_signatur)

    iu = OpenSSL::Digest.new('sha256')
    iu << timestamp
    iu << login
    dig_sig = iu.digest

    # Failsafe Default - return 404, falls die digitale Signatur des request inkorrekt
    return head 404 unless digitale_signatur == Base64.encode64(dig_sig)

    # Model gibt den User an den Controller zurück
    return @user = User.find_by(login: login )
  end

end
