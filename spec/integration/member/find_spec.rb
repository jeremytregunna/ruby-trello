require 'spec_helper'

RSpec.describe 'Trello::Member#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id and get all fields' do
    VCR.use_cassette('member_find_with_id_and_get_all_fields') do
      member = Trello::Member.find('hoppertest')
      expect(member).to be_a(Trello::Member)
      expect(member.id).not_to be_nil
      expect(member.username).to eq('hoppertest')
      expect(member.email).not_to be_nil
      expect(member.full_name).not_to be_nil
      expect(member.initials).not_to be_nil
      # expect(member.avatar_id).not_to be_nil
      expect(member.bio).not_to be_nil
      expect(member.url).not_to be_nil
    end
  end

  it 'find with id and get specific fields' do
    VCR.use_cassette('member_find_with_id_and_get_specific_fields') do
      member = Trello::Member.find('hoppertest', fields: 'username,url')
      expect(member).to be_a(Trello::Member)
      expect(member.id).not_to be_nil
      expect(member.username).to eq('hoppertest')
      expect(member.url).not_to be_nil

      expect(member.email).to be_nil
      expect(member.full_name).to be_nil
      expect(member.initials).to be_nil
      # expect(member.avatar_id).not_to be_nil
      expect(member.bio).to be_nil
    end
  end

end
