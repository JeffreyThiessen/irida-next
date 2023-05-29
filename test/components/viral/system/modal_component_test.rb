# frozen_string_literal: true

require 'application_system_test_case'

module System
  class ModalComponentTest < ApplicationSystemTestCase
    test 'with title' do
      title = 'This is a modal title'
      visit('rails/view_components/modal_component/default')
      within('.Viral-Preview > [data-controller-connected="true"]') do
        assert_text title
        assert_accessible
      end
    end

    test 'with title and body' do
      body = 'This is a modal body'
      visit('rails/view_components/modal_component/default')
      within('.Viral-Preview > [data-controller-connected="true"]') do
        assert_text body
        assert_accessible
      end
    end
  end
end