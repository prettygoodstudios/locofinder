module ApplicationHelper
  def authentication_helper
    if signed_in?
      message = "Welcome #{current_user.email}!"
      content = message + (link_to 'Logout', destroy_user_session_path, method: :delete)
      content.html_safe
    else
      link_to "Log In!", new_user_session_path
    end
  end
end
