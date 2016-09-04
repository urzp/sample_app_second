module SessionsHelper


  def sign_in(user)
    remember_token = User.new_remember_token
    puts "remmember_token=#{remember_token}"
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user #= user
  end

  def signed_in?
    puts "@current_user = #{current_user}"
    !current_user.nil?
  end

  def current_user
    puts "cookies[:remember_token] = #{cookies[:remember_token]}"
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

end
