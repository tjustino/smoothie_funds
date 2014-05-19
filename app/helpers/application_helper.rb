module ApplicationHelper
  def nav_link(name, url, fa)
    class_name = current_page?(url) ? 'active' : nil
    content_tag(:li, class: class_name) { link_to fa_icon(fa, text: name), url }
  end
end
