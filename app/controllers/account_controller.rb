class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # If you want "remember me" functionality, add this before_filter to Application Controller



  def global_submenu
    [
      { :name => '<img src="/images/icons/users.png" class="icon" /> Account Setting', :link => "/account/settings", :selected => "selected" },
#      { :name => '<img src="/images/icons/contact.png" class="icon" /> Parents Information', :link => "/account/parents" },
#      { :name => '<img src="/images/icons/face-smile.png" class="icon" /> Students', :link => "/account/students" },
    ]
  end




  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'login') unless logged_in? # || User.count > 0
    redirect_to(:controller => '/page', :action => 'index')
  end

  def login
    @section_title = "Account Login"
    
    if logged_in?
      redirect_back_or_default(:action => 'index')
    end
    
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])

    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token,
                                  :expires => self.current_user.remember_token_expires_at }
      end
      
      #set last logged in
      
      redirect_back_or_default(:controller => '/page', :action => 'index')
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Your email, password combination is not in the system. Please try again."
    end
  end
  
  def unauthorized
      @s = session[:return_to]
  end
  
  
  def activate
    @section_title = "Your account hasn't been activated, yet!" if logged_in?
    if logged_in?
      redirect_back_or_default(:controller => '/page', :action => 'index') if self.current_user.activated
    else
      redirect_to :action => 'login' 
    end
  end

  def signup
    redirect_to :action => 'activate' if logged_in?
    
    @section_title = "Sign up for an Account"
    
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    
    email_setting = Option.find(:first, :conditions => [ "name = ?", "Sign-up Notification"])
    Notifier.deliver_signup_notification(@user) if email_setting.true? # sends the email
    
    redirect_to :controller => '/account', :action => 'thanks'
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def thanks
    @section_title = "Thanks for signing up, #{current_user.fullname}!"
  end
  
  
  def settings
    @section_title = "Account Settings"
    @submenu = global_submenu
    
    @user = self.current_user
    
    return unless params[:user]
    
    if @user.email == params[:user][:email] and params[:user][:email_confirmation] == ""
      params[:user][:email_confirmation] = params[:user][:email]
    end
    
    if params[:avatar][:uploaded_data] != ""
      @user.avatar.destroy if @user.avatar
      Avatar.create!(params[:avatar])
    end
    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => 'settings'
    else
      render :action => "settings"
    end
  end
  
  def illegal
      render :controller => "page", :action => "illegal"
  end

  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    
    redirect = session[:return_to]
    reset_session
    session[:return_to] = redirect;

    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/page', :action => 'index')
  end
  
  def help
    store_location
    @section_title = "Help"
  end
  
  def emailhelp
    unless params[:email]
      redirect_to :action => "illegal"
    end
    
    # if params[:email][:content] == ""
    #   flash[:notice] = "You can't send an empty email!"
    # elsif
    #   
    # end
  end
  
end







