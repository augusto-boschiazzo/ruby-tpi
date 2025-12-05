class PagesController < ApplicationController
    def home
        @featured_products = Product.includes([:images_attachments]).limit(10)
    end
end
