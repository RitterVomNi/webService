class User < ActiveRecord::Base
  #1:n Beziehung mit User, cascade destroy
  has_many :messages, dependent: :destroy, foreign_key: 'recipient'
  validates :login, uniqueness: true, presence: true
  validates :salt_masterkey, presence: true
  validates :pubkey_user, presence: true
  validates :privkey_user_enc, presence: true

end
