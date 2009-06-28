require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :products
  fixtures :pay_types
  
  # A user goes to the index page. They select a product, adding it to their 
  # cart, and check out, filling in their details on the checkout form. When 
  # they submit, an order is created containing their information, along with a 
  # single line item corresponding to the product they added to their cart. 

  test "buying a product" do  
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby_book)
    
    get "/store/index"
    assert_response :success
    assert_template "index"
    
    xhr :put, "/store/add_to_cart", :id => ruby_book.id
    assert_response :success
    
    cart = session[:cart]
    assert_equal 1, cart.items.size
    assert_equal ruby_book, cart.items[0].product
    
    post "/store/checkout"
    assert_response :success
    assert_template "checkout"
    
    post "/store/checkout",
          :order => { :name     => "Dave Thomas",
                      :address  => "123 Main Street",
                      :email    => "customer@pragprog.com",
                      :pay_type => pay_types(:check).value}
    assert_redirected_to :controller => "store", :action => "index"
    assert_nil session[:cart]
    
    orders = Order.find(:all)
    assert_equal 1, orders.size
    
    order = orders[0]
    assert_equal "Dave Thomas",           order.name
    assert_equal "123 Main Street",       order.address
    assert_equal "customer@pragprog.com", order.email
    assert_equal pay_types(:check).value, order.pay_type
    assert_equal 1, order.line_items.size

    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
    
  end
end
