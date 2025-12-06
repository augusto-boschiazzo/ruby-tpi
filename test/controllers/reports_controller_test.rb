require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get sales_summary" do
    get sales_summary_reports_url
    assert_response :success
  end

  test "should get top_products" do
    get top_products_reports_url
    assert_response :success
  end

  test "should get sales_by_employee" do
    get sales_by_employee_reports_url
    assert_response :success
  end
end
