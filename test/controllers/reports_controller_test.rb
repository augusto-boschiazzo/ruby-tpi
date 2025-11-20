require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get sales_summary" do
    get reports_sales_summary_url
    assert_response :success
  end

  test "should get top_products" do
    get reports_top_products_url
    assert_response :success
  end

  test "should get sales_by_employee" do
    get reports_sales_by_employee_url
    assert_response :success
  end
end
