# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SymphonyClient do
  let(:client) { subject }

  before do
    stub_request(:post, 'https://example.com/symws/user/staff/login')
      .with(body: Settings.symws.login_params.to_h)
      .to_return(body: { sessionToken: 'tokentokentoken' }.to_json)
  end

  describe '#ping' do
    it 'returns true if we can connect to symws' do
      expect(client.ping).to eq true
    end

    context 'when unable to connect' do
      before do
        stub_request(:post, 'https://example.com/symws/user/staff/login').to_timeout
      end

      it 'returns false' do
        expect(client.ping).to eq false
      end
    end
  end

  describe '#session_token' do
    it 'retrieves a session token from symws' do
      expect(client.session_token).to eq 'tokentokentoken'
    end
  end

  describe '#login' do
    before do
      stub_request(:post, 'https://example.com/symws/user/patron/authenticate')
        .with(body: { barcode: '123', password: '321' })
        .to_return(body: { patronKey: 'key' }.to_json)
    end

    it 'authenticates the user against symphony' do
      expect(client.login('123', '321')).to include 'patronKey' => 'key'
    end
  end

  describe '#login_by_sunetid' do
    before do
      stub_request(:get, 'https://example.com/symws/user/patron/search?includeFields=*&q=webAuthID:sunetid')
        .to_return(body: { result: [{ key: 'key' }] }.to_json)
    end

    it 'authenticates the user against symphony' do
      expect(client.login_by_sunetid('sunetid')).to include 'key' => 'key'
    end
  end

  describe '#checkouts' do
    before do
      stub_request(:get, 'https://example.com/symws/user/patron/key/somepatronkey')
        .with(query: hash_including(includeFields: match(/\*/)))
        .to_return(body: { key: 'somepatronkey' }.to_json)
    end

    it 'authenticates the user against symphony' do
      expect(client.checkouts('somepatronkey')).to include 'key' => 'somepatronkey'
    end
  end

  describe '#requests' do
    before do
      stub_request(:get, 'https://example.com/symws/user/patron/key/somepatronkey')
        .with(query: hash_including(includeFields: match(/\*/)))
        .to_return(body: { key: 'somepatronkey' }.to_json)
    end

    it 'authenticates the user against symphony' do
      expect(client.requests('somepatronkey')).to include 'key' => 'somepatronkey'
    end
  end

  describe '#fines' do
    before do
      stub_request(:get, 'https://example.com/symws/user/patron/key/somepatronkey')
        .with(query: hash_including(includeFields: match(/\*/)))
        .to_return(body: { key: 'somepatronkey' }.to_json)
    end

    it 'authenticates the user against symphony' do
      expect(client.fines('somepatronkey')).to include 'key' => 'somepatronkey'
    end
  end

  describe '#patron_info' do
    before do
      stub_request(:get, 'https://example.com/symws/user/patron/key/somepatronkey')
        .with(query: hash_including(includeFields: match(/\*/)))
        .to_return(body: { key: 'somepatronkey' }.to_json)
    end

    it 'authenticates the user against symphony' do
      expect(client.patron_info('somepatronkey').key).to eq 'somepatronkey'
    end
  end
end
