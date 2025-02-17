# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedbackFormsController do
  context 'when the current user is anonymous' do
    context 'when they fill in the reCAPTCHA' do
      it 'sends an email (default scenario)' do
        expect do
          post :create, params: { url: 'http://test.host/', message: 'Howdy' }
        end.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    context 'when they do not fill in the reCAPTCHA' do
      # rubocop:disable RSpec/AnyInstance, RSpec/ExpectInHook
      before do
        expect_any_instance_of(described_class).to receive(:verify_recaptcha).and_return(false)
      end
      # rubocop:enable RSpec/AnyInstance, RSpec/ExpectInHook

      it 'does not send an email' do
        expect do
          post :create, params: { url: 'http://test.host/', message: 'Howdy' }
        end.not_to change(ActionMailer::Base.deliveries, :count)
      end
    end
  end

  describe 'format json' do
    it 'return json success' do
      post :create, params: {
        url: 'http://example.com/',
        message: 'Hello Kittenz',
        format: 'json'
      }
      expect(flash[:success]).to eq 'Thank you! Your feedback has been sent.'
    end
    it 'return html success' do
      post :create, params: {
        url: 'http://test.host/',
        message: 'Hello Kittenz'
      }
      expect(flash[:success]).to eq 'Thank you! Your feedback has been sent.'
    end
  end

  describe 'validate' do
    it 'return an error if no message is sent' do
      post :create, params: {
        url: 'http://test.host/',
        message: '',
        email_address: ''
      }
      expect(flash[:danger]).to eq 'A message is required'
    end
    it 'block potential spam with a url in the message' do
      post :create, params: {
        message: 'I like to spam by sending you a http://www.somespam.com.  lolzzzz',
        url: 'http://test.host/',
        email_address: ''
      }
      expect(flash[:danger]).to eq 'Your message appears to be spam, and has not been sent. Please try sending your message again without any links in the comments.'
    end
    it 'block potential spam with a http:// in the user_agent field' do
      post :create, params: {
        user_agent: 'http://www.google.com',
        message: 'Legit message',
        url: 'http://test.host'
      }
      expect(flash[:danger]).to eq 'Your message appears to be spam, and has not been sent.'
    end
    it 'block potential spam with a http:// in the viewport field' do
      post :create, params: {
        viewport: 'http://www.google.com',
        message: 'Legit message',
        url: 'http://test.host'
      }
      expect(flash[:danger]).to eq 'Your message appears to be spam, and has not been sent.'
    end
    it 'return an error if a bot fills in the email_addrss field (email is correct field)' do
      post :create, params: {
        message: 'I am spamming you!',
        url: 'http://test.host/',
        email_address: 'spam!'
      }
      expect(flash[:danger]).to eq 'You have filled in a field that makes you appear as a spammer.  Please follow the directions for the individual form fields.'
    end
  end
end
