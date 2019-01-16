# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def nav_link(name, url, icon)
    class_name = current_page?(url) ? "active" : nil
    content_tag(:li, class: [class_name, "nav-item"].join(" ")) do
      link_to fa_icon(icon, text: name), url, class: "nav-link"
    end
  end

  def name_or_email
    @current_user.name? ? @current_user.name : @current_user.email
  end

  def icon_text(text, icon_class)
    text[0] == " " ? text : text = " " + text
    icon_class.include?(" icon") ? icon_class : icon_class += " icon"

    content_tag(:i, text, class: icon_class + " icon")
  end

  def shallow_args(parent, child)
    action_name == "new" || action_name == "create" ? [parent, child] : child
  end
end
