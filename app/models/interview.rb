class Interview < ApplicationRecord
    belongs_to :candidate
    has_and_belongs_to_many :users
    has_one :feedback

    validates :location, presence: true, length: { minimum: 3, maximum: 40 }
    validates :url, presence: true, length: { minimum: 3, maximum: 500 }
    validates :scheduled_time, presence: true, length: { minimum: 3, maximum: 20 }

    def with_interviewiers
        interviewers = []
        interview_obj = self.attributes
        self.users.each do |interviewer|
            user = {
                id: interviewer.id,
                email: interviewer.email,
                employee_id: interviewer.employee_id,
            }
        interviewers << user
        end
        interview_obj['interviewers'] = interviewers
        interview_obj
    end

    def with_feedback_and_interviewers
        interview_obj = with_interviewiers
        interview_obj['feedback'] = self.feedback
        interview_obj
    end

    def with_interviewers_and_candidate
        interview_obj = with_interviewiers
        interview_obj['candidate'] = self.candidate
        interview_obj
    end
end
