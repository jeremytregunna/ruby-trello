require 'spec_helper'

module Trello
  RSpec.describe JsonUtils do
    include Helpers

    describe ".from_json" do
      describe "Trello::Card" do
        it "should convert an array of parsed json into cards" do
          cards = Trello::Card.from_json(cards_details)

          expect(cards.size).to eq(cards_details.size)

          card = cards.first
          expect(card).to be_a(Trello::Card)
          expect(card.name).to eq(cards_details.first['name'])
        end

        it "should convert a single parsed json into card" do
          card_details = cards_details.first
          card = Trello::Card.from_json(card_details)

          expect(card).to be_a(Trello::Card)
          expect(card.name).to eq(cards_details.first['name'])
        end
      end
    end

    describe ".from_response" do
      def example_class
        @example_class ||= Class.new do
          include Trello::JsonUtils

          attr_accessor :name, :description

          def initialize(options = {})
            @name = options['name']
            @description = options['description']
          end
        end
      end

      it 'converts json into an instance of a class' do
        expect(example_class.from_response('{}')).to be_a example_class
      end

      it 'supplies the parsed json to the class ctor as a hash' do
        json_text = '{"name" : "Jazz Kang", "description": "Plonker"}'

        result = example_class.from_response json_text
        expect(result.name).to eq("Jazz Kang")
        expect(result.description).to eq("Plonker")
      end

      it 'can also handle arrays of instances of a class' do
        json_text = <<-JSON
      [
       {"name" : "Jazz Kang", "description": "Plonker"},
       {"name" : "Phil Murphy", "description": "Shoreditch hipster"}
      ]
        JSON

        result = example_class.from_response json_text

        expect(result).to be_an Array
        expect(result.size).to eq 2
        result.each do |parsed|
          expect(parsed).to be_a example_class
        end
      end
    end
  end
end
