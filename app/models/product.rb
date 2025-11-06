class Product < ApplicationRecord
  acts_as_paranoid

  belongs_to :product_category

  has_one_attached :audio
  has_many_attached :images

  enum :status, [ :recent, :used ]
  enum :product_type, [ :vinyl, :cd ]

  validates :name, presence: true, uniqueness: true
  validate :audio_only_for_used

  before_destroy :reset_stock

  private

  def audio_only_for_used
    if recent? && audio.attached?
      errors.add(:audio, "solo se puede adjuntar si el producto es usado")
    end
  end

  def reset_stock
    update_column(:stock, 0) # usa update_column para evitar validaciones
  end
end
