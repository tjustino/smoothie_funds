# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def name_or_email(current_user)
    current_user.name? ? current_user.name : current_user.email
  end

  def shallow_args(parent, child)
    action_name == "new" || action_name == "create" ? [ parent, child ] : child
  end

  def icon_text(icon_class, text)
    tag.span(class: "icon-text") do
      tag.div(class: "nowrap") do
        icon(icon_class) + tag.span(text)
      end
    end
  end

  def icon_text_light(icon_class, text)
    tag.span do
      icon(icon_class) + tag.span(text)
    end
  end

  def text_icon(text, icon_class)
    tag.span(class: "icon-text") do
      tag.div(class: "nowrap") do
        tag.span(text) + icon(icon_class)
      end
    end
  end

  def icon(icon_class)
    tag.span(tag.i(class: icon_class), class: "icon")
  end

  def input_class_for(user, symbol)
    user.errors.full_messages_for(symbol).any? ? "input is-danger" : "input"
  end

  def breadcrumb(*items)
    tag.nav class: "breadcrumb", aria: { label: "breadcrumbs" } do
      tag.ul do
        concat tag.li(link_to(icon("fas fa-home"), dashboard_path))
        items.each_with_index do |item, index|
          if index + 1 == items.size
            concat tag.li(item, class: "is-active")
          else
            concat tag.li(item)
          end
        end
      end
    end
  end
end
