# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Contact form', type: :feature do
  context 'with user logged in' do
    before do
      login_as(username: 'SUPER1', patron_key: '521181')
      visit root_path
    end

    describe 'hidden', js: true do
      it 'form should be hidden' do
        expect(page).not_to have_css('#mylibrary-modal', visible: true)
      end
    end

    it 'can have custom library contact information' do
      visit contact_path(library: 'EARTH-SCI')

      expect(page).to have_css 'dd', text: 'Earth Sciences Library (Branner) (brannerlibrary@stanford.edu)'
    end

    describe 'visible', js: true do
      before do
        click_link 'Circulation & Privileges'
      end

      it 'is shown' do
        expect(page).to have_css('#contactForm', visible: true)
      end

      it 'has a Cancel link' do
        expect(page).to have_css('.contact-form a', text: 'Cancel')
      end

      it 'has a Send button' do
        expect(page).to have_css('.contact-form button', text: 'Send')
      end

      describe 'filled out and submitted' do
        before do
          within 'form.contact-form' do
            fill_in('message', with: 'This is only a test')
            click_button 'Send'
          end
        end

        it 'displays a success message' do
          expect(page).to have_css('div.alert-success',
                                   text: 'Thank you! Library staff will be in touch with you soon.')
        end
      end
    end
  end

  context 'with user not logged in' do
    before do
      visit root_path
    end

    describe 'hidden', js: true do
      it 'form should be absent' do
        expect(page).not_to have_css('.contact-form')
      end
    end

    describe 'contact links in the header' do
      it 'does not show the modal form link' do
        expect(page).not_to have_css('.navbar-link', text: 'Circulation & Privileges')
      end

      it 'does not show the telephone number' do
        expect(page).not_to have_css('.navbar-link', text: '(650) 723-1493')
      end
    end
  end

  describe 'form header' do
    before { login_as(username: 'SUPER1', patron_key: '521181') }

    context 'when the standard Circ & Privs link' do
      before { visit contact_path }

      it 'is "Contact Circuation & Privileges"' do
        expect(page).to have_css('h2', text: 'Contact Circulation & Privileges')
      end
    end

    context 'when the library specific link' do
      before { visit contact_path(library: 'LATHROP') }

      it 'is "Contact Library"' do
        expect(page).to have_css('h2', text: 'Contact library')
      end
    end
  end
end
