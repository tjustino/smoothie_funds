class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
  # This means:
  #  • if Current.session is defined, then Current.user will automatically call Current.session.user
  #  • allow_nil: true prevents an error if session is nil -> in this case, Current.user will simply return nil
  # So:
  #  • Current.user is a proxy to Current.session.user
  #  • You cannot do Current.user = User.first directly, because user= point to a method delegated to session
  #  • But you can do Current.session.user = User.first
  #  • Current.session is nil then Current.user will return nil too (thanks to allow_nil: true)
end
