class User < ActiveRecord::Base
  has_many :messages, dependent: :destroy, foreign_key: 'recipient'
  validates :login, uniqueness: true

end
