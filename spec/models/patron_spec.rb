# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Patron do
  subject(:patron) do
    described_class.new(
      {
        key: '1',
        fields: fields
      }.with_indifferent_access
    )
  end

  let(:fields) do
    {
      address1: [
        { 'resource' => '/user/patron/address1',
          'key' => '3',
          'fields' =>
           { 'code' => { 'resource' => '/policy/patronAddress1', 'key' => 'LINE1' },
             'data' => '152B Green Library, 557 Escondido Mall' } },
        { 'resource' => '/user/patron/address1',
          'key' => '4',
          'fields' =>
           { 'code' => { 'resource' => '/policy/patronAddress1', 'key' => 'LINE2' },
             'data' => 'Stanford, CA 94305-6063' } },
        { 'resource' => '/user/patron/address1',
          'key' => '8',
          'fields' =>
           { 'code' => { 'resource' => '/policy/patronAddress1', 'key' => 'EMAIL' },
             'data' => 'superuser1@stanford.edu' } }
      ]
    }
  end

  it 'has a key' do
    expect(patron.key).to eq '1'
  end

  it 'has an email' do
    expect(patron.email).to eq 'superuser1@stanford.edu'
  end

  context 'when there is not an email resource in the patron record' do
    before do
      fields[:address1] = []
    end

    it 'does not have an email' do
      expect(patron.email).to be_nil
    end
  end
end