# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'patron/_patron.html.erb' do
  let(:patron_options) { {} }
  let(:patron) do
    instance_double(
      Patron,
      first_name: 'Jane',
      last_name: 'Stanford',
      patron_type: nil,
      barred?: false,
      status: 'Expired',
      expired_date: Time.zone.today - 10.days,
      proxy_borrower?: false,
      borrow_limit: nil,
      email: nil,
      **patron_options
    )
  end

  before do
    controller.singleton_class.class_eval do
      protected

      def patron; end

      helper_method :patron
    end

    allow(view).to receive(:patron).and_return(patron)
  end

  describe 'Privileges expire' do
    before { render }

    context 'when the user does not have an expire_date' do
      let(:patron_options) { { expired_date: nil } }

      it { expect(rendered).not_to have_css('dt', text: 'Privileges expire') }
    end

    context 'when the user is not a proxy borrower' do
      it { expect(rendered).not_to have_css('dt', text: 'Privileges expire') }
    end

    context 'when the user is a proxy borrower' do
      let(:patron_options) { { proxy_borrower?: true } }

      it { expect(rendered).to have_css('dt', text: 'Privileges expire') }
    end
  end
end
