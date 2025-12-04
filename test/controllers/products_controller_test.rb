require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @user = users(:one)
  end

  test "should get index" do
    sign_in @user

    get products_url
    assert_response :success
  end

  test "should get new" do
    sign_in @user

    get new_product_url
    assert_response :success
  end

  test "should create product" do
    sign_in @user

    assert_difference("Product.count") do
      post products_url, params: { product: { author: @product.author, description: @product.description, name: "Un disco", price: @product.price, product_category_id: @product.product_category_id, product_type: @product.product_type, status: @product.status, stock: @product.stock } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    sign_in @user

    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    sign_in @user

    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    sign_in @user

    patch product_url(@product), params: { product: { author: @product.author, description: @product.description, name: "Other name", price: @product.price, product_category_id: @product.product_category_id, product_type: @product.product_type, status: @product.status, stock: @product.stock } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    sign_in @user

    assert_difference("Product.count", -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
