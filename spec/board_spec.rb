require 'spec_helper'

module Trello
  describe Board do
    include Helpers

    let(:board) { client.find(:board, 'abcdef123456789123456789') }
    let(:client) { Client.new }
    let(:member) { Member.new(JSON.parse(user_payload)) }

    before do
      allow(client)
        .to receive(:get)
        .with("/boards/abcdef123456789123456789", {})
        .and_return JSON.generate(boards_details.first)
    end

    context "finding" do
      let(:client) { Trello.client }

      it "delegates to client#find" do
        expect(client)
          .to receive(:find)
          .with('board', 'abcdef123456789123456789', {})

        Board.find('abcdef123456789123456789')
      end

      it "is equivalent to client#find" do
        expect(Board.find('abcdef123456789123456789')).to eq(board)
      end
    end

    describe '.create' do
      before { allow(Board).to receive(:client).and_return(client) }

      it 'will call create on client with correct parameters' do
        params = {
          name: 'Board Name',
          use_default_labels: true,
          use_default_lists: true,
          description: 'description...',
          organization_id: 11111,
          source_board_id: 22222,
          keep_cards_from_source: true,
          power_ups: 'all',
          visibility_level: 'org',
          voting_permission_level: 'org',
          comment_permission_level: 'org',
          invitation_permission_level: 'admins',
          enable_self_join: true,
          enable_card_covers: true,
          background_color: 'orange',
          card_aging_type: 'pirate'
        }

        expect(client).to receive(:create).with('board', params)

        Board.create(params)
      end
    end

    context "self.all" do
      let(:client) { Trello.client }

      before do
        allow(Member)
          .to receive_message_chain(:find, :username)
          .and_return "testuser"

        allow(client)
          .to receive(:get)
          .with("/members/testuser/boards", {})
          .and_return boards_payload
      end

      it "gets all boards" do
        expect(Board.all.first).to eq Board.new(boards_details.first)
      end
    end

    context "fields" do
      it "gets an id" do
        expect(board.id).to_not be_nil
      end

      it "gets a name" do
        expect(board.name).to_not be_nil
      end

      it "gets the description" do
        expect(board.description).to_not be_nil
      end

      it "knows if it is closed or open" do
        expect(board).to_not be_closed
      end

      it "knows if it is starred or not" do
        expect(board).to_not be_starred
      end

      it "gets its url" do
        expect(board.url).to_not be_nil
      end

      it "gets its last_activity_date" do
        expect(board.last_activity_date).to_not be_nil
      end

      it "gets a Time object for last_activity_date" do
        expect(board.last_activity_date).to be_a(Time)
      end
    end

    context "actions" do
      before do
        allow(client)
          .to receive(:get)
          .with("/boards/abcdef123456789123456789/actions", {filter: :all})
          .and_return actions_payload
      end

      it "has a list of actions" do
        expect(board.actions.count).to be > 0
      end
    end

    context "cards" do
      before do
        allow(client)
          .to receive(:get)
          .with("/boards/abcdef123456789123456789/cards", {filter: :open})
          .and_return cards_payload
      end

      it "gets its list of cards" do
        expect(board.cards.count).to be > 0
      end
    end

    context "labels" do
      before do
        allow(client)
          .to receive(:get)
          .with("/boards/abcdef123456789123456789/labels")
          .and_return label_payload

        allow(client)
          .to receive(:get)
          .with("/boards/abcdef123456789123456789/labelnames")
          .and_return label_name_payload
      end

      it "gets the specific labels for the board" do
        allow(client).to receive(:get).with("/boards/abcdef123456789123456789/labels", {:limit => 1000}).
          and_return label_payload
        labels = board.labels

        expect(labels.count).to eq(4)
        expect(labels[2].color).to  eq('red')
        expect(labels[2].id).to  eq('cbcdef123456789123456789')
        expect(labels[2].board_id).to  eq('abcdef123456789123456789')
        expect(labels[2].name).to  eq('deploy')
        expect(labels[3].color).to  eq('blue')
        expect(labels[3].id).to  eq('dbcdef123456789123456789')
        expect(labels[3].board_id).to  eq('abcdef123456789123456789')
        expect(labels[3].name).to  eq('on hold')
      end

      it "passes the label limit" do
        allow(client).to receive(:get).with("/boards/abcdef123456789123456789/labels", {:limit => 50}).
          and_return label_payload
        labels = board.labels(:limit => 50)
      end
    end

    context "find_card" do
      before do
        allow(client)
          .to receive(:get)
          .with("/boards/abcdef123456789123456789/cards/1")
          .and_return card_payload
      end

      it "gets a card" do
        expect(board.find_card(1)).to be_a(Card)
      end
    end

    context "add_member" do
      before do
        allow(client)
          .to receive(:put)
      end

      it "adds a member to the board as a normal user (default)" do
        expect(client)
          .to receive(:put)
          .with("/boards/abcdef123456789123456789/members/#{member.id}", type: :normal)

        board.add_member(member)
      end

      it "adds a member to the board as an admin" do
        expect(client)
          .to receive(:put)
          .with("/boards/abcdef123456789123456789/members/#{member.id}", type: :admin)

        board.add_member(member, :admin)
      end
    end

    context "remove_member" do
      before do
        allow(client)
          .to receive(:delete)
      end

      it "removes a member from the board" do
        expect(client)
          .to receive(:delete)
          .with("/boards/abcdef123456789123456789/members/#{member.id}")

        board.remove_member(member)
      end
    end

    context "lists" do
      before do
        allow(client)
          .to receive(:get)
          .with("/boards/abcdef123456789123456789/lists", hash_including(filter: :open))
          .and_return lists_payload
      end

      it "has a list of lists" do
        expect(board).to be_has_lists
      end
    end

    context "members" do
      before do
        allow(client)
          .to receive(:get)
          .with("/boards/abcdef123456789123456789/members", hash_including(filter: :all))
          .and_return JSON.generate([user_details])
      end

      it "has a list of members" do
        expect(board.members.count).to be > 0
      end
    end

    context "checklists" do
      before do
        allow(client)
          .to receive(:get)
          .with("/boards/abcdef123456789123456789/checklists", {filter: :all})
          .and_return checklists_payload
      end

      it "has a list of checklists" do
        expect(board.checklists.count).to be > 0
      end
    end

    context "organization" do
      before do
        allow(client)
          .to receive(:get)
          .with("/organizations/abcdef123456789123456789", {})
          .and_return JSON.generate(orgs_details.first)
      end

      it "belongs to an organization" do
        expect(board.organization).to_not be_nil
      end
    end

    context "custom fields" do
      before do
        allow(client)
          .to receive(:get)
          .with("/boards/abcdef123456789123456789/customFields", {})
          .and_return JSON.generate([custom_fields_details.first])
      end

      it "has custom fields" do
        expect(board.custom_fields.count).to be > 0
      end
    end

    describe '#closed?' do
      it "returns the closed attribute" do
        expect(board.closed?).to be_falsy
      end
    end

    describe '#starred?' do
      it "returns the starred attribute" do
        expect(board.starred?).to be_falsy
      end
    end

    describe "#save" do
      let(:client) { Trello.client }

      let(:any_board_json) do
        JSON.generate(boards_details.first)
      end

      before do
        allow(client)
          .to receive(:put)
      end

      it "cannot currently save a new instance" do
        expect(client).to_not receive(:put)
        expect {
          Board.new.save
        }.to raise_error(Trello::ConfigurationError)
      end

      it "mutates the current instance" do
        allow(client)
          .to receive(:put)
          .and_return any_board_json

        board = Board.new 'id' => "xxx"
        expect(board.save).to eq board
      end

      it "uses the correct resource" do
        expected_resource_id = "xxx_board_id_xxx"

        expect(client).to receive(:put) do |path, anything|
          expect(path).to match(/#{expected_resource_id}\z/)
          any_board_json
        end

        Board.new('id' => expected_resource_id).save
      end

      it "saves OR updates depending on whether or not it has an id set"
    end

    describe "Repository" do
      include Helpers

      let(:client) { Trello.client }

      let(:any_board_json) do
        JSON.generate(boards_details.first)
      end

      before do
        allow(client)
          .to receive(:post)
      end

      it "creates a new board with whatever attributes are supplied " do
        expected_attributes = { name: "Any new board name", description: "Any new board desription" }
        sent_attributes = { 'name' => expected_attributes[:name], 'desc' => expected_attributes[:description] }

        expect(client)
          .to receive(:post)
          .with("/boards", sent_attributes)
          .and_return any_board_json

        Board.create expected_attributes
      end

      it "posts to the boards collection" do
        expect(client)
          .to receive(:post)
          .with("/boards", anything)
          .and_return any_board_json

        Board.create xxx: ""
      end

      it "returns a board" do
        allow(client)
          .to receive(:post)
          .with("/boards", anything)
          .and_return any_board_json

        expect(Board.create(xxx: "")).to be_a Board
      end

      it "at least name is required"
    end
  end
end
