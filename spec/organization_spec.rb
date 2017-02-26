require 'spec_helper'

module Trello
  describe Organization do
    include Helpers

    let(:organization) { client.find(:organization, '4ee7e59ae582acdec8000291') }
    let(:client) { Client.new }

    before do
      allow(client)
        .to receive(:get)
        .with('/organizations/4ee7e59ae582acdec8000291', {})
        .and_return organization_payload
    end

    context 'finding' do
      let(:client) { Trello.client }

      it 'delegates to Trello.client#find' do
        expect(client)
          .to receive(:find)
          .with(:organization, '4ee7e59ae582acdec8000291', {})

        Organization.find('4ee7e59ae582acdec8000291')
      end

      it 'is equivalent to client#find' do
        expect(Organization.find('4ee7e59ae582acdec8000291')).to eq(organization)
      end
    end

    context 'actions' do
      it 'retrieves actions' do
        allow(client)
          .to receive(:get)
          .with('/organizations/4ee7e59ae582acdec8000291/actions', { filter: :all })
          .and_return actions_payload

        expect(organization.actions.count).to be > 0
      end
    end

    describe "#update_fields" do
      it "does not set any fields when the fields argument is empty" do
        expected = {
          'id' => 'id',
          'name' => 'name',
          'displayName' => 'display_name',
          'desc' => 'description',
          'url' => 'url',
          'invited' => 'invited',
          'website' => 'website',
          'logoHash' => 'logo_hash',
          'billableMemberCount' => 'billable_member_count',
          'activeBillableMemberCount' => 'active_billable_member_count',
          'memberships' => 'memberships'
        }

        organization = Organization.new(expected)

        organization.update_fields({})

        expected.each do |key, value|
          expect(organization.send(value)).to eq expected[key]
        end
      end
    end
  end
end

