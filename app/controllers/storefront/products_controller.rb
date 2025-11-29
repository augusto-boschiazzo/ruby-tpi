class Storefront::ProductsController < ApplicationController
    def index
        @products = Product.includes(:images_attachments)
                       .where(deleted_at: nil)
                       .order(created_at: :desc)

        @products = @products.where(product_category_id: params[:categories]) if params[:categories].present?
        @products = @products.where(product_type: params[:types]) if params[:types].present?
        @products = @products.where(status: params[:statuses]) if params[:statuses].present?
    end
end
