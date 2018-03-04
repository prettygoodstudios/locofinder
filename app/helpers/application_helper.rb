module ApplicationHelper
  def authentication_helper
    if signed_in?
      content = "<li class='desktop-user-email'>"+link_to(current_user.email, "/user/show/#{current_user.id}")+"</li><li>"+ (link_to 'Edit Account', edit_user_registration_path)+"</li><li>" + (link_to'Sign Out', destroy_user_session_path, method: :delete) +"</li>"
      li = "<li class='user-tab'>#{small_profile_img(User.find(current_user.id))}#{link_to(User.find(current_user.id).email,'/user/show/'+current_user.id.to_s,class: 'mobile-user-email')}<ul>#{content}</ul></li>"
      li.html_safe
    else
      content = "<li>"+link_to("Sign In", new_user_session_path)+"</li>"
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
    generate_profile_img(user, 0.125)
  end
  def large_profile_img(user)
    generate_profile_img(user, 0.500)
  end
  def location_tag(location)
    link = link_to location.title, location, class: "image-card-link"
    image = image_tag "https://s3-us-west-2.amazonaws.com/staticgeofocus/70+by+70.png", width: "20px", height: "20px", style: "display: inline;"
    content = image+link
    content.html_safe
  end
  def image_collection_user(user)
    image = generate_profile_img(user, 0.0625)
    link = link_to user.email, "/user/show/#{user.id}", class: "image-card-link"
    content = image+link
    content.html_safe
  end
  def generate_profile_img(user,scaleRatio)
    zoom = user.zoom.to_f
    if zoom == nil
      zoom  = 0
    end
    finalWidth = 0
    finalHeight = 0
    if user.profile_img.url != nil
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
    image = ""
    if user.profile_img.url != nil
      image = image_tag(user.profile_img.url, style: "width:#{finalWidth}px;height:#{finalHeight}px;margin-left:#{finalOffsetX}px;margin-top:#{finalOffsetY}px;", class: "#{'display-none' if user.profile_img.url == nil}")
    end
    width = (scaleRatio.to_f*400.to_f).to_i
    content = "<div class='profile-img' style='#{'background: black;' if user.profile_img.url != nil}width: #{width}px !important;height: #{width}px !important;'>"+image+"</div>"
    content.html_safe
  end
end
