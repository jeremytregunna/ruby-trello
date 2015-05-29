require 'spec_helper'

module Trello
  describe Item do
    before(:all) do
      @detail = {
        'id'   => 'abcdef123456789123456789',
        'name' => 'test item',
        'type' => 'check',
        'state' => 'complete',
        'pos' => 0
      }

      @item = Item.new(@detail)
    end

    it 'gets its id' do
      @item.id.should == @detail['id']
    end

    it 'gets its name' do
      @item.name.should == @detail['name']
    end

    it 'knows its type' do
      @item.type.should == @detail['type']
    end

    it 'knows its state' do
      @item.state.should == @detail['state']
    end

    it 'knows its pos' do
      @item.pos.should == @detail['pos']
    end

    describe '#complete?' do
      it "knows when it is complete" do
        allow(@item).to receive(:state).and_return "complete"
        expect(@item).to be_complete
      end

      it "knowns when it is not complete" do
        allow(@item).to receive(:state).and_return "incomplete"
        expect(@item).to_not be_complete
      end
    end
  end
end
