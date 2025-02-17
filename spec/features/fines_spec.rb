# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Fines Page', type: :feature do
  let(:user_with_payments) { '521181' }
  let(:user_without_fines) { '521206' }

  before do
    login_as(username: 'SUPER1', patron_key: user_with_payments)
  end

  context 'with fines' do
    it 'totals all the fines into the header' do
      visit fines_path

      expect(page).to have_css('h2', text: 'Payable: $7.00')
    end

    it 'totals all the accruing fines' do
      visit fines_path

      expect(page).to have_css('h2', text: 'Accruing: $72.00')
      expect(page).to have_content 'Fines are accruing on 4 overdue items'
    end

    it 'renders a list item for every fine' do
      visit fines_path

      within('ul.fines') do
        expect(page).to have_css('li', count: 1)
        expect(page).to have_css('li h3', text: 'Research handbook on the law of virtual and augmented reality')
        expect(page).to have_css('li .status', text: 'Damaged item')
        expect(page).to have_css('li a', text: 'Contact library')
      end
    end

    it 'has content behind a toggle', js: true do
      visit fines_path

      within('ul.fines') do
        expect(page).not_to have_css('dl', visible: true)
        expect(page).not_to have_css('dt', text: 'Billed', visible: true)
        click_button 'Expand'
        expect(page).to have_css('dl', visible: true)
        expect(page).to have_css('dt', text: 'Billed', visible: true)
      end
    end
  end

  context 'with no fines' do
    before do
      login_as(username: 'NOTHING', patron_key: user_without_fines)
    end

    it 'does not render table headers' do
      visit fines_path

      expect(page).not_to have_css('.list-header')
    end
  end
end
