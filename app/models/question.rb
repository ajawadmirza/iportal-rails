class Question < ApplicationRecord
  include Filterable

  belongs_to :user

  # query filters
  scope :filter_by_id, ->(id) { where("id = ?", id) }
  scope :filter_by_course, ->(course) { where("course like ?", "%#{course}%") }
  scope :filter_by_description, ->(description) { where("description like ?", "%#{description}%") }
  scope :filter_by_answer, ->(answer) { where("answer like ?", "%#{answer}%") }
  scope :filter_by_priority, ->(priority) { where("priority = ?", priority) }
  scope :filter_by_posted_by, ->(posted_by) { where("user_id = ?", posted_by) }

  validates :course, presence: true, length: { minimum: 3, maximum: 150 }
  validates :description, uniqueness: true, presence: true, length: { minimum: 3, maximum: 3000 }
  validates :answer, presence: true, length: { minimum: 3, maximum: 3000 }
  validates :priority, presence: true

  attribute :priority, :string, default: "1"

  def response_hash
    {
      id: self.id,
      course: self.course,
      description: self.description,
      answer: self.answer,
      priority: self.priority,
      posted_by: self.user&.response_hash,
    }
  end
end
