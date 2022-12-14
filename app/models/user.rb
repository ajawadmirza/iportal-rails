class User < ApplicationRecord
  include Filterable

  # query filter scopes
  scope :filter_by_id, ->(id) { where("id = ?", id) }
  scope :filter_by_activated, ->(activated) { where("activated = ?", activated) }
  scope :filter_by_verified_email, ->(verified_email) { where("verified_email = ?", verified_email) }
  scope :filter_by_email, ->(email) { where("email like ?", "%#{email}%") }
  scope :filter_by_role, ->(role) { where("role = ?", role) }
  scope :filter_by_employee_id, ->(employee_id) { where("employee_id like ?", "%#{employee_id}%") }

  # custom scopes
  scope :having_id_and_activated, ->(id) { where("id in (?)", id).where("activated = ?", true) }
  scope :activated_admins, -> { where("role = ?", ADMIN_USER_ROLE).where("activated = ?", true) }

  has_secure_password
  has_many :candidates
  has_many :questions
  has_and_belongs_to_many :interviews

  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true, length: { minimum: 6, maximum: 500 }
  validates :role, :inclusion => { :in => USER_ROLES, :message => "%{value} value is not defined." }
  validates :employee_id, presence: true, :numericality => { :only_integer => true }

  attribute :activated, :boolean, default: false
  attribute :role, :string, default: "2"
  attribute :verified_email, :boolean, default: false

  def response_hash
    {
      id: self.id,
      email: self.email,
      role: self.role,
      employee_id: self.employee_id,
      activated: self.activated,
      verified_email: self.verified_email
    }
  end
end
