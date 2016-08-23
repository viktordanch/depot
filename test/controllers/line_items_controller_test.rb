require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
    @line_item_2 = line_items(:line_item)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    assert_redirected_to store_path
  end

  test "should create line_item via ajax" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }, xhr: true
    end
    assert_response :success
    assert_select_jquery :html, '#cart' do
      assert_select 'tr#current_item td', /Programming Ruby 1.9/
    end
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    skip("change logic")
    patch line_item_url(@line_item), params: { line_item: { cart_id: @line_item.cart_id, product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to store_url
  end

  test "should decrease line_item quantity" do
    assert_difference('LineItem.count', 0) do
      delete line_item_url(@line_item_2)
    end

    assert_equal @line_item.quantity, 1
    assert_redirected_to store_url
  end
  test "should decrease line_item quantity via ajax" do
    post line_items_url, params: { product_id: products(:ruby).id }, xhr: true
    post line_items_url, params: { product_id: products(:ruby).id }, xhr: true
    @cart = Cart.find(session[:cart_id])
    line_item = @cart.line_items.first

    assert_difference('LineItem.count', 0) do
      delete line_item_url(line_item), xhr: true
    end

    assert_response :success
    assert_equal 1, @cart.line_items.first.quantity
    assert_select_jquery :html, '#cart' do
      assert_select "tr.item_id_#{line_item.id}", 1
    end
  end
end
