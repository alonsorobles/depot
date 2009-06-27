class StoreController < ApplicationController
  before_filter :set_time
  before_filter :set_in_checkout
  before_filter :find_cart, :except => :empty_cart
  
  def index
    @products = Product.find_products_for_sale
    
    if session[:counter].nil?
      session[:counter] = 1
    else
      session[:counter] += 1
    end
    @counter = session[:counter]
    
    respond_to do |format|
      format.html
      format.xml {render :layout => false, :xml => @products.to_xml}
    end
  end
  
  def add_to_cart
    product = Product.find(params[:id])
    @current_item = @cart.add_product(product)
      respond_to do |format|
        format.js if request.xhr?
        format.html {redirect_to_index}
      end
    session[:counter] = 0
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid product #{params[:id]}")
    redirect_to_index "Invalid product"
  end
  
  def remove_from_cart
    product = Product.find(params[:id])
    @current_item = @cart.remove_product(product)
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid product #{params[:id]}")
    redirect_to_index "Invalid product"
  end
  
  def empty_cart
    session[:cart] = nil
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
  end
  
  def checkout
    @in_checkout = true
    if @cart.items.empty?
      redirect_to_index("Your cart is empty")
    elsif request.post? && params[:order] != nil
      @order = Order.new(params[:order])
      @order.add_line_items_from_cart(@cart)
      if @order.save
        session[:cart] = nil
        redirect_to_index(I18n.t("flash.thanks"))
      end
    else
      @order = Order.new
    end
  end
  
  protected
    def authorize
    end
  
  private
    def set_time
      @time = Time.now
    end
    
    def find_cart
      @cart = (session[:cart] ||= Cart.new)
    end
    
    def redirect_to_index(msg = nil)
      flash[:notice] = msg if msg
      redirect_to :action => "index"
    end
    
    def set_in_checkout
      @in_checkout = false
    end
end
