module ApplicationHelper
  def authentication_helper
    if signed_in?
      content = "<li>"+link_to(current_user.email, "/user/show/#{current_user.id}")+"</li><li>"+ (link_to 'Edit Acount', edit_user_registration_path)+"</li><li>" + (link_to'Logout', destroy_user_session_path, method: :delete) +"</li>"
      li = "<li class='user-tab'>#{small_profile_img(User.find(current_user.id))}<ul>#{content}</ul></li>"
      li.html_safe
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
  def small_profile_img(user)
    scaleRatio = 0.125
    zoom = user.zoom.to_f
    if zoom == nil
      zoom  = 0
    end
    finalWidth = 0
    finalHeight = 0 
    if user.profile_img != nil
      finalWidth  = scaleRatio * user.profile_img.width * zoom
      finalHeight = scaleRatio * user.profile_img.height * zoom
    end
    finalOffsetX = 0
    finalOffsetY = 0
    if user.offsetX != nil
      finalOffsetX = user.offsetX*scaleRatio
      finalOffsetY = user.offsetY*scaleRatio
    end
    #These two lines can be uncommented and used for diagnostics
    #puts "Width: #{finalWidth}, Height: #{finalHeight}, offSetX: #{user.offsetX*scaleRatio}, offsetY: #{user.offsetY*scaleRatio}"
    #puts "Width: #{user.profile_img.width}, Height: #{user.profile_img.height}, offSetX: #{user.offsetX}, offsetY: #{user.offsetY}"
    content = "<div class='profile-img' style='#{'background: black;' if user.profile_img.height != 0}'>"+image_tag(user.profile_img.url, style: "width:#{finalWidth}px;height:#{finalHeight}px;margin-left:#{finalOffsetX}px;margin-top:#{finalOffsetY}px;", class: "#{'display-none' if user.profile_img.url == nil}")+"</div>"
    content.html_safe
  end
end
