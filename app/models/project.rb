class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: { message: "Name is required" }
  validates :description, presence: { message: "Description is required" }
end
