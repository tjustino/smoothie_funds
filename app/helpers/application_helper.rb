# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def nav_link(name, url, icon)
    class_name = current_page?(url) ? "active" : nil
    content_tag(:li, class: [class_name, "nav-item"].join(" ")) do
      link_to icon_text(icon, name), url, class: "nav-link"
    end
  end

  def name_or_email
    @current_user.name? ? @current_user.name : @current_user.email
  end

  def shallow_args(parent, child)
    action_name == "new" || action_name == "create" ? [parent, child] : child
  end

  def icon_text(icon_class, text)
    safe_join [icon(icon_class), " ", text]
  end

  def icon(icon_class)
    # icon_class.include?(" icon") ? icon_class : icon_class += " icon"
    content_tag(:i, nil, class: icon_class)
  end
end
