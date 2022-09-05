class User < ApplicationRecord
    has_secure_password
    has_many :candidates
    has_and_belongs_to_many :interviews

    validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password_digest, presence: true, length: { minimum: 6, maximum: 500 }
    validates :role, :inclusion  => { :in => USER_ROLES, :message => "%{value} value is not defined." }
    validates :employee_id, presence: true, :numericality => { :only_integer => true }

    attribute :activated, :boolean, default: false
    attribute :role, :string, default: '2'
end
