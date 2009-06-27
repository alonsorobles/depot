class AdminController < ApplicationController
  def login
    if request.post?
      if User.count.zero?
        create_session_and_redirect
      else
        user = User.authenticate params[:name], params[:password]
        if user
          create_session_and_redirect user.id
        else
          flash.now[:notice] = "Invalid user/password combination"
        end
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out."
    redirect_to :action => :login
  end

  def index
    @total_orders = Order.count
  end
  
  private
    def create_session_and_redirect(user_id = -1)
      session[:user_id] = user_id
      uri = session[:original_uri]
      session[:original_uri] = nil
      if user_id == -1
        redirect_to :controller => 'users', :action => 'new'
      else
        redirect_to (uri || {:action => :index})
      end
    end

end
