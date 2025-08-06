class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Include Pagy backend module for pagination
  include Pagy::Backend
  
  # Require authentication for all actions by default
  before_action :authenticate_user!
end
