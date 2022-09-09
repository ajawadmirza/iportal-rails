class Interview < ApplicationRecord
    belongs_to :candidate
    has_and_belongs_to_many :users
    has_one :feedback

    validates :location, presence: true, length: { minimum: 3, maximum: 40 }
    validates :url, presence: true, length: { minimum: 3, maximum: 500 }
    validates :scheduled_time, presence: true, length: { minimum: 3, maximum: 20 }

    def response_hash
        {
            id: self.id,
            scheduled_time: self.scheduled_time,
            location: self.location,
            url: self.url,
            candidate_id: self.candidate.id
        }
    end

    def with_interviewiers
        interviewers = []
        self.users.each_entry{ |interviewer| interviewers << interviewer&.response_hash }
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
