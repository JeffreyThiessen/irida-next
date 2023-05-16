# frozen_string_literal: true

require 'application_system_test_case'

module System
  class TooltipComponentTest < ApplicationSystemTestCase
    test 'tooltip appears on hover' do
      visit('/rails/view_components/tooltip_component/default')
      within('.Viral-Preview > [data-controller-connected="true"]') do
        assert_selector '[data-viral--tooltip-component-target="target"]', visible: false
        find('a', text: 'Hover me').hover
        assert_text I18n.t('auth.scopes.api')
        assert_selector '[data-viral--tooltip-component-target="target"]', visible: true
      end
    end
  end
end