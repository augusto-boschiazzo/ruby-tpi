class Product < ApplicationRecord
  acts_as_paranoid

  belongs_to :product_category

  # Para item_sales
  has_many :item_sales
  has_many :sales, through: :item_sales

  has_one_attached :audio
  has_one_attached :cover
  has_many_attached :images

  enum :status, [ :recent, :used ]
  enum :product_type, [ :vinyl, :cd ]

  validates :name, presence: true, uniqueness: true
  validates :stock,
            numericality: { greater_than_or_equal_to: 0 },
            presence: true,
            if: -> { recent? }

  validates :stock, inclusion: { in: [ 0, 1 ] }, if: -> { used? }

  validate :audio_only_for_used
  validate :audio_must_be_an_audio_file

  before_validation :normalize_stock
  before_destroy :reset_stock

  after_save :purge_audio_if_requested

  attr_accessor :remove_audio


  private

  def normalize_stock
    # Si es 'used', el stock debe ser nil, no "" ni "0"
    self.stock = 1 if used?
  end

  def audio_only_for_used
    return if remove_audio == "1"

    if recent? && audio.attached?
      errors.add(:audio, "solo se puede adjuntar si el producto es usado")
    end
  end

  def audio_must_be_an_audio_file
    return if recent?
    return unless audio.attached?

    unless audio.content_type.start_with?("audio")
      errors.add(:audio, "debe ser un archivo de audio (mp3, wav, ogg, etc.)")
      audio.purge
    end
  end

  def reset_stock
    update_column(:stock, 0) # usa update_column para evitar validaciones
  end

  def purge_audio_if_requested
    audio.purge if remove_audio == "1"
  end
end
