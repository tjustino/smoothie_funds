# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  # menu
  def name_or_email
    @current_user.name? ? @current_user.name : @current_user.email
  end

                # needed?
                def shallow_args(parent, child)
                  action_name == "new" || action_name == "create" ? [parent, child] : child
                end

  # icons
  def nbsp
    [160].pack("U*")
  end

  def single_icon(icon)
    tag.i(class: icon)
  end

  def icon_text(icon, text)
    safe_join([single_icon(icon), text], nbsp)
  end

  def text_icon(text, icon)
    safe_join([text, single_icon(icon)], nbsp)
  end

  def icon_text_icon(first_icon, text, second_icon = nil)
    second_icon = first_icon if second_icon.nil?
    safe_join([single_icon(first_icon), text, single_icon(second_icon)], nbsp)
  end
end
