require 'spec_helper'

RSpec.describe 'Trello::BasicData.one' do

  let(:client_double) { double('client') }
  let(:organization) { double('organization') }

  around do |example|
    module Trello
      class FakeOrganization < BasicData
      end
      class FakeBoard < BasicData
        def update_fields(fields)
          attributes[:id] = fields[:id]
        end
      end
    end

    example.run

    Trello.send(:remove_const, 'FakeBoard')
    Trello.send(:remove_const, 'FakeOrganization')
  end

  def mock_client_and_association(klass: Trello::FakeOrganization, id: 1, path: nil, id_field: :id)
    association_restful_name = path
    allow(Trello::FakeBoard).to receive(:client).and_return(client_double)
    allow_any_instance_of(Trello::FakeBoard).to receive(:client).and_return(client_double)
    allow_any_instance_of(Trello::FakeBoard).to receive(id_field).and_return(id)
    if association_restful_name
      allow(client_double).to receive(:find).with(association_restful_name, id).and_return(organization)
    else
      allow(klass).to receive(:find).with(id).and_return(organization)
    end
  end

  context 'when only pass in the name' do
    before do
      Trello::FakeBoard.class_eval { one :fake_organization }

      mock_client_and_association
    end

    it 'can get the association from client' do
      expect(Trello::FakeBoard.new(id: 1).fake_organization).to eq(organization)
    end
  end

  context 'when pass in name with path' do
    before do
      Trello::FakeBoard.class_eval { one :fake_organization, path: 'organizations' }

      mock_client_and_association(path: 'organizations')
    end

    it 'can get the association from client' do
      expect(Trello::FakeBoard.new(id: 1).fake_organization).to eq(organization)
    end
  end

  context 'when pass in name with via' do
    before do
      Trello::FakeBoard.class_eval { one :fake_organization, via: Trello::FakeOrganization }

      mock_client_and_association
    end

    it 'can get the association from client' do
      expect(Trello::FakeBoard.new(id: 1).fake_organization).to eq(organization)
    end
  end

  context 'when pass in name with using' do
    before do
      Trello::FakeBoard.class_eval { one :fake_organization, using: :test_id }

      mock_client_and_association(id_field: :test_id)
    end

    it 'can get the association from client' do
      expect(Trello::FakeBoard.new(id: 1).fake_organization).to eq(organization)
    end
  end
end
