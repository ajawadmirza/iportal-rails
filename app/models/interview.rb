class Interview < ApplicationRecord
    belongs_to :candidate
    has_and_belongs_to_many :users

    validates :location, presence: true, length: { minimum: 3, maximum: 40 }
    validates :url, presence: true, length: { minimum: 3, maximum: 500 }
    validates :scheduled_time, presence: true, length: { minimum: 3, maximum: 20 }
end
