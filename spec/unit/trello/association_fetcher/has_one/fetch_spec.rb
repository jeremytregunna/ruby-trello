require 'spec_helper'

RSpec.describe Trello::AssociationFetcher::HasOne::Fetch do

  describe '.execute' do
    let(:client) { instance_double(Trello::Client) }
    let(:association_owner) { double('association_owner', client: client) }
    let(:association_restful_id) { 1 }
    let(:association_class) { double('association_class') }
    let(:result) { double('result') }

    let(:params) { instance_double('params',
      association_owner: association_owner,
      association_restful_name: association_restful_name,
      association_restful_id: association_restful_id,
      association_class: association_class
    )}

    context 'when association_restful_name exists' do
      let(:association_restful_name) { 'organizations' }

      before do
        allow(Trello).to receive(:client).and_return(client)
        allow(client)
          .to receive(:find)
          .with(association_restful_name, association_restful_id)
          .and_return(result)
      end

      it 'return the result from Trello.client' do
        expect(Trello::AssociationFetcher::HasOne::Fetch.execute(params)).to eq(result)
      end
    end

    context 'when association_restful_name does not exist' do
      let(:association_restful_name) { nil }

      before do
        allow(association_class)
          .to receive(:find)
          .with(association_restful_id)
          .and_return(result)
      end

      it 'return the result from association_class' do
        expect(Trello::AssociationFetcher::HasOne::Fetch.execute(params)).to eq(result)
      end
    end
  end

end
