module ApplicationHelper
  def authentication_helper
    if signed_in?
      message = "Welcome #{current_user.email}!"
      content = message + (link_to 'Logout', destroy_user_session_path, method: :delete) + (link_to 'Edit Acount', edit_user_registration_path)
      content.html_safe
    else
      link_to "Log In!", new_user_session_path
    end
  end
  def views_helper views
    if views < 1000
      return views.to_s
    else
      return (views/1000).floor.to_s + "K"
    end
  end
end
