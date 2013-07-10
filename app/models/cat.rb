class Cat < ActiveRecord::Base
  attr_accessible :age, :birthdate, :color, :name, :sex, :user_id

  validates :color, :name, :presence => true

  has_many :cat_rental_requests, :dependent => :destroy
  belongs_to :user

end
