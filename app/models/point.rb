class Point < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :number, presence: true, length: { maximum: 8 }, uniqueness: true
  validates :kind, presence: true, length: { maximum: 50 }
end
