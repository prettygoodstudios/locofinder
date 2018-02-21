module ApplicationHelper
  def authentication_helper
    if signed_in?
      content = "<li>" + (link_to'Logout', destroy_user_session_path, method: :delete) +"</li><li>"+ (link_to 'Edit Acount', edit_user_registration_path)+"</li>"
      content.html_safe
    else
      content = "<li>"+link_to("Log In!", new_user_session_path)+"</li>"
      content.html_safe
    end
  end
  def views_helper views
    if views < 1000
      return views.to_s
    else
      return (views/1000).floor.to_s + "K"
    end
  end
  def is_mine_or_admin(id)
    retVal = false
    if signed_in?
      if (current_user.id == id and current_user.verified) or current_user.role == "admin"
        retVal = true
      end
    end
    retVal
  end
end
