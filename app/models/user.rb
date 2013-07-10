class User < ActiveRecord::Base
  attr_accessible :password, :session_token, :username

  validates :password, :username, :presence => true
  validates :username, :uniqueness => true

  has_many :cats
end
