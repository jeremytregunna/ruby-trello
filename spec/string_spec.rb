require 'spec_helper'
require 'trello/core_ext/string'

describe String, '#json_into' do
  include Helpers

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
    expect('{}'.json_into(example_class)).to be_a example_class
  end

  it 'supplies the parsed json to the class ctor as a hash' do
    expect(example_class)
      .to receive(:new)
      .once
      .with({
        "name"        => "Jazz Kang",
        "description" => "Plonker"
      })

    json_text = '{"name" : "Jazz Kang", "description": "Plonker"}'

    json_text.json_into example_class
  end

  it 'can also handle arrays of instances of a class' do
    json_text = <<-JSON
      [
       {"name" : "Jazz Kang", "description": "Plonker"},
       {"name" : "Phil Murphy", "description": "Shoreditch hipster"}
      ]
    JSON

    result = json_text.json_into example_class

    expect(result).to be_an Array
    expect(result.size).to eq 2
    result.each do |parsed|
      expect(parsed).to be_a example_class
    end
  end
end

