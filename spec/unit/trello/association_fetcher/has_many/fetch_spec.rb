require 'spec_helper'

RSpec.describe Trello::AssociationFetcher::HasMany::Fetch do

  describe '.execute' do
    let(:client) { instance_double(Trello::Client) }
    let(:owner_class) { double('OwnerClass') }
    let(:association_owner) { double('association_owner') }
    let(:path) { '/test' }
    let(:filter_params) { { a: 1 } }
    let(:resources) { double('resources') }
    let(:result) { double('result') }

    let(:params) { instance_double('params',
      owner_class: owner_class,
      association_owner: association_owner,
      path: path,
      filter_params: filter_params
    ) }

    before do
      allow(Trello).to receive(:client).and_return(client)
      allow(client)
        .to receive(:find_many)
        .with(owner_class, path, filter_params)
        .and_return(resources)
      allow(Trello::MultiAssociation)
        .to receive(:new)
        .with(association_owner, resources)
        .and_return(double('multi-association', proxy: result))
    end

    it 'return the result from Trello.client and MultiAssociation' do
      expect(Trello::AssociationFetcher::HasMany::Fetch.execute(params)).to eq(result)
    end
  end

end
