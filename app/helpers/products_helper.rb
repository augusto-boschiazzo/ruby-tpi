module ProductsHelper
  def status_options
    Product.statuses.keys.collect { |status| [ Product.human_attribute_name(status.underscore), status ] }
  end

  def product_type_options
    Product.product_types.keys.collect { |product_type| [ Product.human_attribute_name(product_type.underscore), product_type ] }
  end
end
