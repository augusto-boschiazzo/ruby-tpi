class Client < ApplicationRecord
  has_many :sales
  validates :dni, presence: true, uniqueness: true
  validates :name, presence: true
end
