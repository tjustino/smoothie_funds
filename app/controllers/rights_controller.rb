class RightsController < ApplicationController
  allow_unauthenticated_access

  # GET /terms
  def terms; end

  # GET /cookie
  def cookie; end

  # GET /gdpr
  def gdpr; end
end
