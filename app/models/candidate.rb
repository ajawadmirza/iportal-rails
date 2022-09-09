class Candidate < ApplicationRecord
    belongs_to :user
    has_many :interviews

    validates :name, presence: true, length: { minimum: 3, maximum: 40 }
    validates :cv_url, presence: true, url: true
    validates :cv_key, presence: true, length: { minimum: 3, maximum: 40 }
    validates :status, presence: true, length: { minimum: 3, maximum: 40 }
    validates :stack, presence: true, length: { minimum: 3, maximum: 40 }
    validates :experience_years, presence: true, :numericality => { :only_integer => true, less_than_or_equal_to: 100 }

    def response_hash
        {
            id: self.id,
            name: self.name,
            cv_url: self.cv_url,
            cv_key: self.cv_key,
            status: self.status,
            stack: self.stack,
            referred_by: self.user&.response_hash,
            experience_years: self.experience_years
        }
    end

    def with_interviews_interviewers_and_feedback
        interviews = []
        self.interviews.each_entry{ |interview| interviews << interview&.with_feedback_and_interviewers }
        interview_obj = self.response_hash
        interview_obj[:interviews] = interviews
        interview_obj
    end
end
