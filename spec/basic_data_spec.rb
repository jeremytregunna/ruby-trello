require 'spec_helper'

module Trello
  describe BasicData do
    describe "equality" do
      specify "two objects of the same type are equal if their id values are equal" do
        data_object = Card.new('id' => 'abc123')
        other_data_object = Card.new('id' => 'abc123')

        expect(data_object).to eq(other_data_object)
      end

      specify "two object of the samy type are not equal if their id values are different" do
        data_object = Card.new('id' => 'abc123')
        other_data_object = Card.new('id' => 'def456')

        expect(data_object).not_to eq(other_data_object)
      end

      specify "two object of different types are not equal even if their id values are equal" do
        card = Card.new('id' => 'abc123')
        list = List.new('id' => 'abc123')

        expect(card.id).to eq(list.id)
        expect(card).to_not eq(list)
      end
    end
  end
end
