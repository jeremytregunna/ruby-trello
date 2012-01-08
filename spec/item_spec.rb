require 'spec_helper'

module Trello
  describe Item do
    before(:all) do
      @detail = {
        'id'   => "abcdef123456789123456789",
        'name' => "test item",
        'type' => "check"
      }

      @item = Item.new(@detail)
    end

    it "gets its id" do
      @item.id.should == @detail['id']
    end

    it "gets its name" do
      @item.name.should == @detail['name']
    end

    it "knows its type" do
      @item.type.should == @detail['type']
    end
  end
end