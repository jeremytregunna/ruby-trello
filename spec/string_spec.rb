require "spec_helper"
require "trello/string"

describe String, "#json_into" do
  include Helpers

  def example_class
    @example_class ||= Class.new do
      attr_accessor :name, :description

      def initialize(options = {})
        @name = options['name']
        @description = options['description']
      end
    end
  end

  it "converts json into an instance of a class" do
    "{}".json_into(example_class).should be_an_instance_of example_class
  end

  it "supplies the parsed json to the class's ctor as a hash" do
    example_class.should_receive(:new).once.with({
      "name"        => "Jazz Kang",
      "description" => "Plonker"
    })
    
    json_text = '{"name" : "Jazz Kang", "description": "Plonker"}'
    
    json_text.json_into example_class
  end

  it "can also handle arrays of instances of a class" do
    json_text = <<-JSON
      [
       {"name" : "Jazz Kang", "description": "Plonker"},
       {"name" : "Phil Murphy", "description": "Shoreditch hipster"}
      ]
    JSON
    
    result = json_text.json_into example_class

    result.should be_an Array
    result.size.should == 2
    result.each do |parsed|
      parsed.should be_an_instance_of example_class
    end
  end
end
 
