# frozen_string_literal: true

require "securerandom"

class ProductCarouselComponent < ViewComponent::Base
  MAX_VISIBLE = 5

  attr_reader :products, :visible, :card_size, :title, :subtitle, :show_arrows

  def initialize(products:, visible: MAX_VISIBLE, card_size: :md, title: nil, subtitle: nil, show_arrows: true)
    @products = Array(products).compact
    @visible = normalized_visible(visible)
    @card_size = card_size
    @title = title
    @subtitle = subtitle
    @show_arrows = show_arrows
  end

  def dom_id
    @dom_id ||= "product-carousel-#{SecureRandom.hex(4)}"
  end

  def total_items
    products.size
  end

  def display_arrows?
    show_arrows && total_items > visible
  end

  def empty?
    products.blank?
  end

  private

  def normalized_visible(desired)
    value = desired.to_i
    value = MAX_VISIBLE if value > MAX_VISIBLE
    value = 1 if value < 1
    value
  rescue StandardError
    MAX_VISIBLE
  end
end
