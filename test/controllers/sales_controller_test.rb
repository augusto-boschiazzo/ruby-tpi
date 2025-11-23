require "test_helper"

class SalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sale = sales(:one)
    @user = users(:one)
  end

  test "should get index" do
    sign_in @user

    get sales_url
    assert_response :success
  end

  test "should get new" do
    sign_in @user

    get new_sale_url
    assert_response :success
  end

  test "should create sale" do
    sign_in @user

    client_attributes = { dni: 123456, name: "Pedro" }
    item_sales_attributes = { "0": item_sales(:one).attributes.slice("product_id", "quantity", "unit_price") }

    assert_difference("Sale.count") do
      post sales_url, params: {
        sale: {
          user_id: @sale.user_id,
          client_attributes: client_attributes,
          item_sales_attributes: item_sales_attributes
        }
      }
    end

    assert_redirected_to sale_url(Sale.last)
  end

  test "should show sale" do
    sign_in @user

    get sale_url(@sale)
    assert_response :success
  end
end
