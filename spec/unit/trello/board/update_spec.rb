require 'spec_helper'

RSpec.describe 'Trello::Board#update!' do

  let(:client) { Trello.client }
  let(:board) { Trello::Board.new(id: 'abc123') }

  before { allow(board).to receive(:from_response_v2) }

  it 'can update name through client' do
    board.name = 'Board 1'

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        name: 'Board 1'
      })

    board.update!
  end

  it 'can update description through client' do
    board.description = 'description ...'

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        desc: 'description ...'
      })

    board.update!
  end

  it 'can update closed through client' do
    board.closed = true

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        closed: true
      })

    board.update!
  end

  # it 'can update subscribed through client' do
  # end

  it 'can update organization_id through client' do
    board.organization_id = 123

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        idOrganization: 123
      })

    board.update!
  end

  it 'can update visibility_level through client' do
    board.visibility_level = 'org'

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        'prefs/permissionLevel': 'org'
      })

    board.update!
  end

  it 'can update self_join_permission_level through client' do
    board.self_join_permission_level = 'org'

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        'prefs/selfJoin': 'org'
      })

    board.update!
  end

  it 'can update enable_card_covers through client' do
    board.enable_card_covers = true

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        'prefs/cardCovers': true
      })

    board.update!
  end

  # it 'can update hide_votes through client' do
  # end

  it 'can update invitation_permission_level through client' do
    board.invitation_permission_level = 'org'

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        'prefs/invitations': 'org'
      })

    board.update!
  end

  it 'can update voting_permission_level through client' do
    board.voting_permission_level = 'org'

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        'prefs/voting': 'org'
      })

    board.update!
  end

  it 'can update comment_permission_level through client' do
    board.comment_permission_level = 'org'

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        'prefs/comments': 'org'
      })

    board.update!
  end

  it 'can update background_color through client' do
    board.background_color = 'blue'

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        'prefs/background': 'blue'
      })

    board.update!
  end

  it 'can update card_aging_type through client' do
    board.card_aging_type = 'pirate'

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        'prefs/cardAging': 'pirate'
      })

    board.update!
  end

  # it 'can update enable_calendar_feed through client' do
  # end

  it 'can update all through client' do
    board.name = 'Board 1'
    board.description = 'description ...'
    board.closed = true
    board.organization_id = 123
    board.visibility_level = 'org'
    board.self_join_permission_level = 'org'
    board.enable_card_covers = true
    board.invitation_permission_level = 'org'
    board.voting_permission_level = 'org'
    board.comment_permission_level = 'org'
    board.background_color = 'blue'
    board.card_aging_type = 'pirate'

    expect(client)
      .to receive(:put)
      .with('/boards/abc123/', {
        name: 'Board 1',
        desc: 'description ...',
        closed: true,
        idOrganization: 123,
        'prefs/permissionLevel': 'org',
        'prefs/selfJoin': 'org',
        'prefs/cardCovers': true,
        'prefs/invitations': 'org',
        'prefs/voting': 'org',
        'prefs/comments': 'org',
        'prefs/background': 'blue',
        'prefs/cardAging': 'pirate'
      })

    board.update!
  end

end
