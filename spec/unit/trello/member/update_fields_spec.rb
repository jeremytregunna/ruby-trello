require 'spec_helper'

RSpec.describe 'Trello::Member#update_fields' do

  let(:member_params) { {
    'id' => '5e93ba403f1ab3603ba81a09',
    'bio' => 'test',
    'username' => 'hoppertest',
    'email' => 'test@test.com'
   } }

  let(:member) { Trello::Member.new(member_params) }

  context 'when the fields argument is empty' do
    let(:fields) { {} }

    it 'member does not set any fields' do
      member.update_fields(fields)

      expect(member.changed?).to be_falsy
      expect(member.id).to eq(member_params['id'])
      expect(member.username).to eq(member_params['username'])
      expect(member.email).to eq(member_params['email'])
    end
  end

  context 'when the fields argument has at least one field' do

    context 'and the field does changed' do
      let(:fields) { { username: 'hopperchange' } }

      it 'member does set the changed fields' do
        member.update_fields(fields)

        expect(member.username).to eq('hopperchange')
      end

      it 'member has been mark as changed' do
        member.update_fields(fields)

        expect(member.changed?).to be_truthy
      end
    end

    context "and the field doesn't changed" do
      let(:fields) { { username: member_params['username'] } }

      it "member attributes doesn't changed" do
        member.update_fields(fields)

        expect(member.username).to eq(member_params['username'])
      end

      it "member hasn't been mark as changed" do
        member.update_fields(fields)

        expect(member.changed?).to be_falsy
      end
    end

    context "and the field isn't a correct attributes of the card" do
      let(:fields) { { abc: 'abc' } }

      it "card attributes doesn't changed" do
        member.update_fields(fields)

        expect(member.id).to eq(member_params['id'])
        expect(member.username).to eq(member_params['username'])
        expect(member.email).to eq(member_params['email'])
      end

      it "card hasn't been mark as changed" do
        member.update_fields(fields)

        expect(member.changed?).to be_falsy
      end
    end
  end

end
