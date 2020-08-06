require 'spec_helper'

RSpec.describe 'Trello::Board.create' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the board partial parameters' do
    VCR.use_cassette('can_success_create_a_board') do
      board = Trello::Board.create(
        name: 'IT 99',
        description: 'testing board create',
        closed: false,
        organization_id: '5e93ba154634282b6df23bcc'
      )
      expect(board).to be_a(Trello::Board)

      expect(board.name).to eq('IT 99')
      expect(board.description).to eq('testing board create')
      expect(board.id).not_to be_nil
      expect(board.closed).to be_falsy
      expect(board.organization_id).to eq('5e93ba154634282b6df23bcc')
    end
  end

  it 'can success create board with full parameters' do
    VCR.use_cassette('can_success_create_a_board_with_full_parameters') do
      board = Trello::Board.create(
        name: 'IT 100',
        use_default_labels: false,
        use_default_lists: false,
        description: 'testing board create',
        organization_id: '5e93ba154634282b6df23bcc',
        source_board_id: '5e94eaf386374970d06e4c89',
        keep_cards_from_source: 'cards',
        visibility_level: 'org',
        voting_permission_level: 'org',
        comment_permission_level: 'org',
        invitation_permission_level: 'members',
        enable_self_join: false,
        enable_card_covers: false,
        background_color: 'grey'
      )
      expect(board).to be_a(Trello::Board)

      expect(board.name).to eq('IT 100')
      expect(board.id).not_to be_nil
      expect(board.organization_id).to eq('5e93ba154634282b6df23bcc')
      # expect(board.source_board_id).to eq('5e94eaf386374970d06e4c89') #TODO
      expect(board.visibility_level).to eq('org')
      expect(board.voting_permission_level).to eq('org')
      expect(board.comment_permission_level).to eq('org')
      expect(board.invitation_permission_level).to eq('members')
      expect(board.enable_self_join).to eq(false)
      expect(board.enable_card_covers).to eq(false)
      expect(board.background_color).to eq('grey')
    end
  end

  it 'can success create board without clone from other board' do
    VCR.use_cassette('can_success_create_a_board_without_clone_from_other') do
      board = Trello::Board.create(
        name: 'IT 101',
        use_default_labels: false,
        use_default_lists: false,
        description: 'testing board create',
        organization_id: '5e93ba154634282b6df23bcc',
        visibility_level: 'org',
        voting_permission_level: 'org',
        comment_permission_level: 'org',
        invitation_permission_level: 'members',
        enable_self_join: false,
        enable_card_covers: false,
        background_color: 'grey'
      )
      expect(board).to be_a(Trello::Board)

      expect(board.name).to eq('IT 101')
      expect(board.description).to eq('testing board create')
      expect(board.id).not_to be_nil
      expect(board.organization_id).to eq('5e93ba154634282b6df23bcc')
      # expect(board.use_default_labels).to eq(false) # TODO
      # expect(board.use_default_lists).to eq(false) # TODO
      expect(board.description).to eq('testing board create')
      expect(board.visibility_level).to eq('org')
      expect(board.voting_permission_level).to eq('org')
      expect(board.comment_permission_level).to eq('org')
      expect(board.invitation_permission_level).to eq('members')
      expect(board.enable_self_join).to eq(false)
      expect(board.enable_card_covers).to eq(false)
      expect(board.background_color).to eq('grey')
    end
  end

end
