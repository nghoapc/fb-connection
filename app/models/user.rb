class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
         # :recoverable, :rememberable, :validatable
	devise :database_authenticatable, :validatable, :omniauthable

	has_many :facebook_pages
	def self.from_omniauth(auth)
	  where(fb_id: auth.uid).first_or_create do |user|
	    user.email = auth.info.email
	    user.password = Devise.friendly_token[0, 20]
	    user.name = auth.info.name   # assuming the user model has a name
	    # user.skip_confirmation!
	  end
	end
end
