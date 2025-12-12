# app/components/image_carrousel_component.rb
class ImageCarrouselComponent < ViewComponent::Base
  def initialize(cover:, images:, current_index: 0, product:)
    @images = []
    @images << cover if cover.attached?
    @images.concat(images.to_a) if images.attached?
    @current_index = current_index.to_i
    @product = product
  end

  def images
    @images
  end

  def current_index
    @current_index
  end

  def total
    @images.size
  end

  def current_image
    @images[@current_index]
  end

  def next_index
    (@current_index + 1) % total
  end

  def prev_index
    (@current_index - 1) % total
  end
end
