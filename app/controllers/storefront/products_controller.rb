class Storefront::ProductsController < ApplicationController
    def index
        @products = Product.includes(:images_attachments, :audio_attachment)
                       .where(deleted_at: nil)
                       .order(created_at: :desc)

        @products = @products.where(product_category_id: params[:categories]) if params[:categories].present?
        @products = @products.where(product_type: params[:types]) if params[:types].present?
        @products = @products.where(status: params[:statuses]) if params[:statuses].present?
        if params[:query].present?
            params[:query].downcase.split.each do |word| 
                @products = @products.where(
                    "LOWER(name) LIKE :q OR LOWER(author) LIKE :q",
                q: "%#{word}%"
            )
            end
        end
        @products = @products.where(year: params[:year].to_i) if params[:year].present?

    end
end
