class Feedback < ApplicationRecord
    include Filterable

    belongs_to :interview
    belongs_to :user

    scope :filter_by_id, -> (id) { where('id = ?', id) }
    scope :filter_by_status, -> (status) { where('status like ?', "%#{status}%") }
    scope :filter_by_remarks, -> (remarks) { where('remarks like ?', "%#{remarks}%") }
    scope :filter_by_file_url, -> (file_url) { where('file_url like ?', "%#{file_url}%") }
    scope :filter_by_given_by, -> (given_by) { where('user_id = ?', given_by) }

    validates :status, presence: true, length: { minimum: 3, maximum: 15 }
    validates :remarks, presence: true, length: { minimum: 3, maximum: 300 }
    validates :file_url, presence: true, length: { minimum: 3, maximum: 500 }
    validates :file_key, presence: true, length: { minimum: 3, maximum: 40 }
    validates :interview_id, presence: true, uniqueness: true

    def response_hash
        {
            id: self.id,
            status: self.status,
            remarks: self.remarks,
            file_url: self.file_url,
            file_key: self.file_key,
            given_by: self.user&.response_hash
        }
    end

    def with_interview_and_candidate_details
        feedback = self.response_hash
        feedback['interview'] = self.interview&.with_interviewers_and_candidate
        feedback
    end
end
