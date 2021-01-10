# require 'spec_helper'

# RSpec.describe 'Trell::Member.update!' do
#   include IntegrationHelpers

#   before { setup_trello }

#   it 'can update! a member' do
#     VCR.use_cassette('can_success_update_bong_a_member') do
#       member = Trello::Member.find('hoppertest')
#       member.bio = 'test'
#       member.update!

#       member = Trello::Member.find('hoppertest')
#       expect(member.bio).to eq('test')
#     end
#   end
# end
