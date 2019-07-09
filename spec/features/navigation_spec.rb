# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Navigation', type: :feature do
  it 'the root path navigates to the Summary page' do
    visit root_path

    expect(page).to have_css('h1', text: 'Summary')
  end

  it 'has navigation with links to the main pages' do
    visit root_path

    within('nav') do
      expect(page).to have_link('Summary')
    end
  end
end
