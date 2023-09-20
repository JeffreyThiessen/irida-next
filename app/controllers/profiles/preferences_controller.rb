# frozen_string_literal: true

# Purpose: To handle the user's site preferences
module Profiles
  # Controller for the user personal preferences page
  class PreferencesController < Profiles::ApplicationController
    def show
      authorize! @user, to: :read?
    end
  end
end