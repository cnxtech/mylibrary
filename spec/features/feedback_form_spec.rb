# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feedback form', type: :feature do
  context 'when not logged in' do
    it 'reCAPTCHA challenge is present' do
      visit feedback_path
      expect(page).to have_css '.mylibrary-captcha'
    end
  end

  context 'with js', js: true do
    before do
      login_as(username: 'SUPER1', patron_key: '521181')
      visit root_path
    end

    it 'feedback form should be hidden' do
      expect(page).not_to have_css('#feedback-form', visible: true)
    end
    it 'feedback form should be shown filled out and submitted' do
      click_link 'Feedback'
      skip('Passes locally, not on Travis.') if ENV['CI']
      expect(page).to have_css('#feedback-form', visible: true)
      expect(page).to have_css('button', text: 'Cancel')
      within 'form.feedback-form' do
        fill_in('message', with: 'This is only a test')
        fill_in('name', with: 'Ronald McDonald')
        fill_in('to', with: 'test@kittenz.eu')
        click_button 'Send'
      end
      expect(page).to have_css('div.alert-success', text: 'Thank you! Your feedback has been sent.')
    end
  end

  context 'without js' do
    before do
      login_as(username: 'SUPER1', patron_key: '521181')
      visit root_path
    end

    it 'reCAPTCHA challenge is present' do
      visit feedback_path
      expect(page).not_to have_css '.mylibrary-captcha'
    end

    it 'feedback form should be shown filled out and submitted' do
      click_link 'Feedback'
      expect(page).to have_css('#feedback-form', visible: true)
      expect(page).to have_css('a', text: 'Cancel')
      within 'form.feedback-form' do
        fill_in('message', with: 'This is only a test')
        fill_in('name', with: 'Ronald McDonald')
        fill_in('to', with: 'test@kittenz.eu')
        click_button 'Send'
      end
      expect(page).to have_css('div.alert-success', text: 'Thank you! Your feedback has been sent.')
    end
  end
end
