require 'spec_helper'

module Trello
  describe Board do
    include Helpers

    before(:each) do
      Client.stub(:get).with("/boards/abcdef123456789123456789").
        and_return JSON.generate(boards_details.first)

      @board = Board.find('abcdef123456789123456789')
    end

    context "fields" do
      it "gets an id" do
        @board.id.should_not be_nil
      end

      it "gets a name" do
        @board.name.should_not be_nil
      end

      it "gets the description" do
        @board.description.should_not be_nil
      end

      it "knows if it is closed or open" do
        @board.closed?.should_not be_nil
      end

      it "gets its url" do
        @board.url.should_not be_nil
      end
    end

    context "actions" do
      it "has a list of actions" do
        Client.stub(:get).with("/boards/abcdef123456789123456789/actions", {:filter => :all}).
          and_return actions_payload

        @board.actions.count.should be > 0
      end
    end

    context "cards" do
      it "gets its list of cards" do
        Client.stub(:get).with("/boards/abcdef123456789123456789/cards", { :filter => :open }).
          and_return cards_payload

        @board.cards.count.should be > 0
      end
    end

    context "lists" do
      it "has a list of lists" do
        Client.stub(:get).with("/boards/abcdef123456789123456789/lists", hash_including(:filter => :open)).
          and_return lists_payload

        @board.has_lists?.should be true
      end
    end

    context "members" do
      it "has a list of members" do
        Client.stub(:get).with("/boards/abcdef123456789123456789/members", hash_including(:filter => :all)).
          and_return JSON.generate([user_details])

        @board.members.count.should be > 0
      end
    end

    context "organization" do
      it "belongs to an organization" do
        Client.stub(:get).with("/organizations/abcdef123456789123456789").
          and_return JSON.generate(orgs_details.first)

        @board.organization.should_not be_nil
      end
    end

    it "is not closed" do
      @board.closed?.should_not be_true
    end
  end

  describe "#update_fields" do
    it "does not set any fields when the fields argument is empty" do
      expected = {
       'id' => "id",
       'name' => "name",
       'desc' => "desc",
       'closed' => false,
       'url' => "url",
       'idOrganization' => "org_id"
      }

      board = Board.new(expected)

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
    include Helpers

    let(:any_board_json) do
      JSON.generate(boards_details.first)      
    end

    it "cannot currently save a new instance" do
      Client.should_not_receive :put
      
      the_new_board = Board.new
      lambda{the_new_board.save}.should raise_error
    end

    it "puts all fields except id" do
      expected_fields = %w{name description closed}.map{|s| s.to_sym}
        
      Client.should_receive(:put) do |anything, body|
        body.keys.should =~ expected_fields
        any_board_json
      end
      
      the_new_board = Board.new 'id' => "xxx"
      the_new_board.save
    end

    it "mutates the current instance" do
      Client.stub(:put).and_return any_board_json
      
      board = Board.new 'id' => "xxx"
      
      the_result_of_save = board.save

      the_result_of_save.should equal board
    end

    it "uses the correct resource" do
      expected_resource_id = "xxx_board_id_xxx"

      Client.should_receive(:put) do |path, anything|
        path.should =~ /#{expected_resource_id}\/$/
        any_board_json
      end
      
      the_new_board = Board.new 'id' => expected_resource_id
      the_new_board.save
    end 

    it "saves OR updates depending on whether or not it has an id set"
  end
  
  describe "Repository" do
    include Helpers

    let(:any_board_json) do
      JSON.generate(boards_details.first)      
    end

    it "creates a new board with whatever attributes are supplied " do
      expected_attributes = { :name => "Any new board name", :description => "Any new board desription" }
      sent_attributes = { :name => expected_attributes[:name], :desc => expected_attributes[:description] }

      Client.should_receive(:post).with("/boards", sent_attributes).and_return any_board_json

      Board.create expected_attributes
    end

    it "posts to the boards collection" do
      Client.should_receive(:post).with("/boards", anything).and_return any_board_json

      Board.create :xxx => ""
    end

    it "returns a board" do
      Client.stub(:post).with("/boards", anything).and_return any_board_json

      the_new_board = Board.create :xxx => ""
      the_new_board.should be_a Board
    end
    
    it "at least name is required"
  end
end
