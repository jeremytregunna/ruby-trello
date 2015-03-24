require 'spec_helper'

module Trello
  describe Board do
    include Helpers

    let(:board) { client.find(:board, 'abcdef123456789123456789') }
    let(:client) { Client.new }
    let(:member) { Member.new(user_payload) }

    before(:each) do
      client.stub(:get).with("/boards/abcdef123456789123456789", {}).
        and_return JSON.generate(boards_details.first)
    end

    context "finding" do
      let(:client) { Trello.client }

      it "delegates to client#find" do
        client.should_receive(:find).with(:board, 'abcdef123456789123456789', {})
        Board.find('abcdef123456789123456789')
      end

      it "is equivalent to client#find" do
        Board.find('abcdef123456789123456789').should eq(board)
      end
    end

    context "self.all" do
      let(:client) { Trello.client }

      it "gets all boards" do
        Member.stub_chain(:find, :username).and_return "testuser"
        client.stub(:get).with("/members/testuser/boards").and_return boards_payload

        expected = Board.new(boards_details.first)
        Board.all.first.should eq(expected)
      end
    end

    context "fields" do
      it "gets an id" do
        board.id.should_not be_nil
      end

      it "gets a name" do
        board.name.should_not be_nil
      end

      it "gets the description" do
        board.description.should_not be_nil
      end

      it "knows if it is closed or open" do
        board.closed?.should_not be_nil
      end
      
      it "knows if it is starred or not" do
        board.starred?.should_not be_nil
      end

      it "gets its url" do
        board.url.should_not be_nil
      end
    end

    context "actions" do
      it "has a list of actions" do
        client.stub(:get).with("/boards/abcdef123456789123456789/actions", {filter: :all}).
          and_return actions_payload

        board.actions.count.should be > 0
      end
    end

    context "cards" do
      it "gets its list of cards" do
        client.stub(:get).with("/boards/abcdef123456789123456789/cards", { filter: :open }).
          and_return cards_payload

        board.cards.count.should be > 0
      end
    end

    context "labels" do
      it "gets the specific labels for the board" do
        client.stub(:get).with("/boards/abcdef123456789123456789/labels").
          and_return label_payload
        labels = board.labels false
        labels.count.should eq(4)


        expect(labels[2].color).to  eq('red')
        expect(labels[2].id).to  eq('abcdef123456789123456789')
        expect(labels[2].board_id).to  eq('abcdef123456789123456789')
        expect(labels[2].name).to  eq('deploy')
        expect(labels[2].uses).to  eq(2)

        expect(labels[3].color).to  eq('blue')
        expect(labels[3].id).to  eq('abcdef123456789123456789')
        expect(labels[3].board_id).to  eq('abcdef123456789123456789')
        expect(labels[3].name).to  eq('on hold')
        expect(labels[3].uses).to  eq(6)
      end

      it "gets the specific labels for the board" do
        client.stub(:get).with("/boards/abcdef123456789123456789/labelnames").
          and_return label_name_payload

        board.labels.count.should eq(10)
      end
    end

    context "find_card" do
      it "gets a card" do
        client.stub(:get).with("/boards/abcdef123456789123456789/cards/1").
          and_return card_payload
        board.find_card(1).should be_a(Card)
      end
    end

    context "add_member" do
      it "adds a member to the board as a normal user (default)" do
        client.stub(:put).with("/boards/abcdef123456789123456789/members/id", type: :normal)
        board.add_member(member)
      end

      it "adds a member to the board as an admin" do
        client.stub(:put).with("/boards/abcdef123456789123456789/members/id", type: :admin)
        board.add_member(member, :admin)
      end
    end

    context "remove_member" do
      it "removes a member from the board" do
        client.stub(:delete).with("/boards/abcdef123456789123456789/members/id")
        board.remove_member(member)
      end
    end

    context "lists" do
      it "has a list of lists" do
        client.stub(:get).with("/boards/abcdef123456789123456789/lists", hash_including(filter: :open)).
          and_return lists_payload

        board.has_lists?.should be true
      end
    end

    context "members" do
      it "has a list of members" do
        client.stub(:get).with("/boards/abcdef123456789123456789/members", hash_including(filter: :all)).
          and_return JSON.generate([user_details])

        board.members.count.should be > 0
      end
    end

    context "organization" do
      it "belongs to an organization" do
        client.stub(:get).with("/organizations/abcdef123456789123456789", {}).
          and_return JSON.generate(orgs_details.first)

        board.organization.should_not be_nil
      end
    end

    it "is not closed" do
      expect(board.closed?).not_to be(true)
    end
    
     it "is not starred" do
      expect(board.starred?).not_to be(true)
    end

    describe "#update_fields" do
      it "does not set any fields when the fields argument is empty" do
        expected = {
         'id' => "id",
         'name' => "name",
         'desc' => "desc",
         'closed' => false,
         'starred' => false,
         'url' => "url",
         'idOrganization' => "org_id"
        }

        board = Board.new(expected)
        board.client = client

        board.update_fields({})

        expected.each_pair do |key, value|
          if board.respond_to?(key)
            board.send(key).should == value
          end
        end

        board.description.should == expected['desc']
        board.organization_id.should == expected['idOrganization']
      end

      it "sets any attributes supplied in the fields argument"
    end

    describe "#save" do
      let(:client) { Trello.client }

      let(:any_board_json) do
        JSON.generate(boards_details.first)
      end

      it "cannot currently save a new instance" do
        client.should_not_receive :put

        the_new_board = Board.new
        -> { the_new_board.save }.should raise_error
      end

      it "puts all fields except id" do
        expected_fields = %w{ name description closed starred idOrganization}.map { |s| s.to_sym }

        client.should_receive(:put) do |anything, body|
          body.keys.should =~ expected_fields
          any_board_json
        end

        the_new_board = Board.new 'id' => "xxx"
        the_new_board.save
      end

      it "mutates the current instance" do
        client.stub(:put).and_return any_board_json

        board = Board.new 'id' => "xxx"

        the_result_of_save = board.save

        the_result_of_save.should equal board
      end

      it "uses the correct resource" do
        expected_resource_id = "xxx_board_id_xxx"

        client.should_receive(:put) do |path, anything|
          path.should =~ /#{expected_resource_id}\/$/
          any_board_json
        end

        the_new_board = Board.new 'id' => expected_resource_id
        the_new_board.save
      end

      it "saves OR updates depending on whether or not it has an id set"
    end

    describe '#update!' do
      let(:client) { Trello.client }

      let(:any_board_json) do
        JSON.generate(boards_details.first)
      end

      it "puts basic attributes" do
        board = Board.new 'id' => "board_id"

        board.name        = "new name"
        board.description = "new description"
        board.closed      = true
        board.starred      = true

        client.should_receive(:put).with("/boards/#{board.id}/", {
          name: "new name",
          description: "new description",
          closed: true,
          starred: true,
          idOrganization: nil
        }).and_return any_board_json
        board.update!
      end
    end

    describe "Repository" do
      include Helpers

      let(:client) { Trello.client }

      let(:any_board_json) do
        JSON.generate(boards_details.first)
      end

      it "creates a new board with whatever attributes are supplied " do
        expected_attributes = { name: "Any new board name", description: "Any new board desription" }
        sent_attributes = { name: expected_attributes[:name], desc: expected_attributes[:description] }

        client.should_receive(:post).with("/boards", sent_attributes).and_return any_board_json

        Board.create expected_attributes
      end

      it "posts to the boards collection" do
        client.should_receive(:post).with("/boards", anything).and_return any_board_json

        Board.create xxx: ""
      end

      it "returns a board" do
        client.stub(:post).with("/boards", anything).and_return any_board_json

        the_new_board = Board.create xxx: ""
        the_new_board.should be_a Board
      end

      it "at least name is required"
    end
  end
end
