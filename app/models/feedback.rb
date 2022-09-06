class Feedback < ApplicationRecord
    belongs_to :interview
    belongs_to :user

    validates :status, presence: true, length: { minimum: 3, maximum: 15 }
    validates :remarks, presence: true, length: { minimum: 3, maximum: 300 }
    validates :file_url, presence: true, length: { minimum: 3, maximum: 500 }
    validates :file_key, presence: true, length: { minimum: 3, maximum: 40 }

    def with_interview_and_candidate_details
        feedback = self.attributes
        feedback['interview'] = self.interview.with_interviewers_and_candidate
        feedback
    end
end
