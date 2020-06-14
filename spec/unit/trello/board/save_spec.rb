require 'spec_helper'

RSpec.describe 'Trello::Board' do

  context 'when id exists' do
    let(:board) { Board.new(id: 1) }

    it 'call #update! on board' do
      expect(board).to receive(:update!)

      board.save
   end
  end

  context 'when id does not exist' do
    let(:board) { Board.new(
      name: 'IT 1',
      description: 'description ...',
      organization_id: 1111,
      visibility_level: 'org',
      voting_permission_level: 'org',
      comment_permission_level: 'org',
      invitation_permission_level: 'org',
      enable_self_join: true,
      enable_card_covers: true,
      background_color: 'blue',
      card_aging_type: 'pirate'
    ) }

    it 'call #create on board with correct parameters' do
      expect(board).to receive(:post).with('/boards', {
        'name' => 'IT 1',
        'desc' => 'description ...',
        'idOrganization' => 1111,
        'prefs_permissionLevel' => 'org',
        'prefs_voting' => 'org',
        'prefs_comments' => 'org',
        'prefs_invitations' => 'org',
        'prefs_selfJoin' => true,
        'prefs_cardCovers' => true,
        'prefs_background' => 'blue',
        'prefs_cardAging' => 'pirate'
      })

      board.save
    end
  end

end
