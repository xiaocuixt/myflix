# 这里表示rspec的宏指令，可以在其它rspec方法中调用这里定义的方法。

def set_current_user
  john = Fabricate(:user)
  session[:user_id] = john.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end