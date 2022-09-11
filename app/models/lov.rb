class Lov < ApplicationRecord
  include Filterable

  scope :filter_by_id, ->(id) { where("id = ?", id) }
  scope :filter_by_category, ->(category) { where("category like ?", "%#{category}%") }

  validates :name, presence: true, length: { minimum: 1, maximum: 200 }, uniqueness: { scope: [:category] }
  validates :value, presence: true, length: { minimum: 1, maximum: 200 }
  validates :category, presence: true, length: { minimum: 1, maximum: 200 }

  def response_hash
    {
      id: self.id,
      category: self.category,
      name: self.name,
      value: self.value,
    }
  end
end
