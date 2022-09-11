class Interview < ApplicationRecord
  include Filterable

  belongs_to :candidate
  has_and_belongs_to_many :users
  has_one :feedback

  scope :filter_by_id, ->(id) { where("id = ?", id) }
  scope :filter_by_scheduled_time, ->(scheduled_time) { where("scheduled_time like ?", "%#{scheduled_time}%") }
  scope :filter_by_location, ->(location) { where("location like ?", "%#{location}%") }
  scope :filter_by_url, ->(url) { where("url like ?", "%#{url}%") }
  scope :filter_by_has_feedback, (lambda do |has_feedback|
          return self.select { |interview| interview.feedback == nil } unless has_feedback.casecmp("true") == 0
          return self.select { |interview| interview.feedback != nil } if has_feedback.casecmp("true") == 0
        end)
  scope :filter_by_total_interviewers, (lambda do |total_interviewers|
          self.select { |interview| interview.users.count == total_interviewers.to_i }
        end)
  scope :filter_by_till, (lambda do |query_time|
          till = Time.parse(query_time)
          self.select { |interview| Time.parse(interview.scheduled_time) <= till }
        end)
  scope :filter_by_from, (lambda do |query_time|
          till = Time.parse(query_time)
          self.select { |interview| Time.parse(interview.scheduled_time) >= till }
        end)

  validates :location, presence: true, length: { minimum: 3, maximum: 40 }
  validates :url, presence: true, length: { minimum: 3, maximum: 500 }
  validates :scheduled_time, presence: true, length: { minimum: 3, maximum: 20 }

  def response_hash
    {
      id: self.id,
      scheduled_time: self.scheduled_time,
      location: self.location,
      url: self.url,
      candidate_id: self.candidate.id,
    }
  end

  def with_interviewiers
    interviewers = []
    self.users.each_entry { |interviewer| interviewers << interviewer&.response_hash }
    interview_obj = self.response_hash
    interview_obj[:interviewers] = interviewers
    interview_obj
  end

  def with_feedback_and_interviewers
    interview_obj = with_interviewiers
    interview_obj[:feedback] = self.feedback&.response_hash
    interview_obj
  end

  def with_interviewers_and_candidate
    interview_obj = with_interviewiers.except(:candidate_id)
    interview_obj[:candidate] = self.candidate&.response_hash
    interview_obj
  end

  def with_feedback_interviewers_and_candidate
    interview_obj = with_interviewiers.except(:candidate_id)
    interview_obj[:candidate] = self.candidate&.response_hash
    interview_obj[:feedback] = self.feedback&.response_hash
    interview_obj
  end
end
