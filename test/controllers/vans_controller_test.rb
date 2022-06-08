require "test_helper"

class VansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @van = vans(:one)
  end

  test "should get index" do
    get vans_url
    assert_response :success
  end

  test "should get new" do
    get new_van_url
    assert_response :success
  end

  test "should create van" do
    assert_difference('Van.count') do
      post vans_url, params: { van: { vmodel: @van.vmodel, notes: @van.notes, vmake: @van.vmake, vyear: @van.vyear } }
    end

    assert_redirected_to van_url(Van.last)
  end

  test "should show van" do
    get van_url(@van)
    assert_response :success
  end

  test "should get edit" do
    get edit_van_url(@van)
    assert_response :success
  end

  test "should update van" do
    patch van_url(@van), params: { van: { vmodel: @van.vmodel, notes: @van.notes, vmake: @van.vmake, vyear: @van.vyear } }
    assert_redirected_to van_url(@van)
  end

  test "should destroy van" do
    assert_difference('Van.count', -1) do
      delete van_url(@van)
    end

    assert_redirected_to vans_url
  end
end
