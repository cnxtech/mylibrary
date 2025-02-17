# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Request do
  subject do
    described_class.new({
      key: '1',
      fields: fields
    }.with_indifferent_access)
  end

  let(:request) { subject }
  let(:fields) do
    {
      status: 'ACTIVE',
      queuePosition: '3',
      queueLength: '7',
      bib: {
        key: '1184859',
        fields: {
          title: 'The Lego movie videogame [electronic resource]',
          author: 'Cool people made this'
        }
      },
      item: {
        fields: {
          call: {
            fields: {
              dispCallNumber: 'ZMS 4033',
              sortCallNumber: 'ZMS 004033'
            }
          }
        }
      }
    }
  end

  it 'has a key' do
    expect(request.key).to eq '1'
  end

  it 'has a status' do
    expect(request.status).to eq 'ACTIVE'
  end

  it 'has a title' do
    expect(request.title).to eq 'The Lego movie videogame [electronic resource]'
  end

  it 'has an author' do
    expect(request.author).to eq 'Cool people made this'
  end

  it 'has a call number' do
    expect(request.call_number).to eq 'ZMS 4033'
  end

  it 'has a shelf key' do
    expect(request.shelf_key).to eq 'ZMS 004033'
  end

  it 'has a catkey' do
    expect(request.catkey).to eq '1184859'
  end

  it 'has the queue length' do
    expect(request.queue_length).to eq '7'
  end

  it 'has the queue position' do
    expect(request.queue_position).to eq '3'
  end

  it 'is not from borrow direct' do
    expect(request).not_to be_from_borrow_direct
  end

  context 'without an associated item or bib' do
    before do
      fields[:item] = nil
      fields[:bib] = nil
    end

    it 'has no title' do
      expect(request.title).to eq nil
    end

    it 'has no author' do
      expect(request.author).to eq nil
    end

    it 'has no catkey' do
      expect(request.catkey).to eq nil
    end

    it 'has no call number' do
      expect(request.call_number).to eq nil
    end

    it 'has no shelf key' do
      expect(request.shelf_key).to eq nil
    end
  end

  context 'when a hold is for an on order item' do
    before do
      fields[:item] = nil
      fields[:queuePosition] = nil
      fields[:queueLength] = nil
    end

    it 'has an unknown waitlist position' do
      expect(request.waitlist_position).to eq 'Unknown'
    end
  end

  context 'when the placed_library is SUL' do
    before { fields[:placedLibrary] = { key: 'SUL' } }

    it 'represents itself as coming from BorrowDirect' do
      expect(request.placed_library).to eq 'BORROW_DIRECT'
    end

    it 'is from borrow direct' do
      expect(request).to be_from_borrow_direct
    end
  end
end
