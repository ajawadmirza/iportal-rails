class Candidate < ApplicationRecord
    belongs_to :user

    validates :name, presence: true, length: { minimum: 3, maximum: 40 }
    validates :cv_url, presence: true, url: true
    validates :cv_key, presence: true, length: { minimum: 3, maximum: 40 }
    validates :status, presence: true, length: { minimum: 3, maximum: 40 }
    validates :stack, presence: true, length: { minimum: 3, maximum: 40 }
    validates :referred_by, presence: true, length: { minimum: 3, maximum: 40 }
    validates :experience_years, presence: true, :numericality => { :only_integer => true, less_than_or_equal_to: 100 }
end
