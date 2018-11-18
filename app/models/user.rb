class User < ApplicationRecord
	has_many :blogs
	before_validation {email.downcase!}
	validates :email,{
		length:   {maximum: 255},
    uniqueness: true,
    format:   {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}
	}
	validates :name,{
		presence: true
	}
	has_secure_password
	validates :password,{
		presence: true,
		length:   {minimum: 6}
	}
end
