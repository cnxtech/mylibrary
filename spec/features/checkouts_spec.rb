# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Checkout Page', type: :feature do
  before do
    login_as(username: 'SUPER1', patron_key: '521181')
  end

  it 'has checkout data' do
    visit checkouts_path

    expect(page).to have_css('ul.checkouts', count: 1)
    expect(page).to have_css('ul.checkouts li', count: 12)

    within(first('ul.checkouts li')) do
      expect(page).to have_css('.title', text: /Law and justice in Japanese popular culture/)
      expect(page).to have_css('.call_number', text: 'P96 .J852 J353 2018')
    end
  end

  it 'has recall data' do
    visit checkouts_path

    expect(page).to have_css('ul.recalled-checkouts', count: 1)
    expect(page).to have_css('ul.recalled-checkouts li', count: 1)

    within(first('ul.recalled-checkouts li')) do
      expect(page).to have_css('.title', text: /Pikachu's global adventure/)
      expect(page).to have_css('.call_number', text: 'GV1469.35 .P63 P54 2004')
    end
  end

  it 'hides some data behind a toggle', js: true do
    visit checkouts_path

    within(first('ul.checkouts li')) do
      expect(page).not_to have_css('dl', visible: true)
      expect(page).not_to have_css('dt', text: 'Borrowed on:', visible: true)
      click_button '➕'
      expect(page).to have_css('dl', visible: true)
      expect(page).to have_css('dt', text: 'Borrowed on:', visible: true)
    end
  end

  it 'translates the library code from the response into a name' do
    visit checkouts_path

    within(first('ul.checkouts li')) do
      expect(page).to have_css('dl dd', text: 'Law Library (Crown)', visible: false)
    end
  end
end
