require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get sales_summary" do
    get sales_summary_admin_reports_url
    assert_response :success
  end

  test "should get top_products" do
    get top_products_admin_reports_url
    assert_response :success
  end

  test "should get sales_by_employee" do
    get sales_by_employee_admin_reports_url
    assert_response :success
  end

  test "employee should not access sales_summary" do
    sign_in_employee
    get sales_summary_admin_reports_url

    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

  test "employee should not access top_products" do
    sign_in_employee
    get top_products_admin_reports_url

    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

  test "employee should not access sales_by_employee" do
    sign_in_employee
    get sales_by_employee_admin_reports_url

    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

  private

  def sign_in_employee
    sign_out @user
    sign_in users(:two)
  end
end
