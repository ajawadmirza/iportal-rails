class User < ApplicationRecord
    has_secure_password

    validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password_digest, presence: true, length: { minimum: 6, maximum: 500 }
    validates :role, :inclusion  => { :in => USER_ROLES, :message => "%{value} value is not defined." }

    attribute :activated, :boolean, default: false
    attribute :role, :string, default: '2'
end
