require 'spec_helper'

RSpec.describe 'Trello::RegisterAttrs' do

  around do |example|
    module Trello
      class FakeCard < BasicData
      end
    end

    example.run

    Trello.send(:remove_const, 'FakeCard')
  end

  let(:attribute_1) { double('attribute 1') }
  let(:attribute_2) { double('attribute 2') }
  let(:attribute_3) { double('attribute 3') }

  let(:schema) { double('Trello::Schema',
    attrs: {
      name: attribute_1,
      desc: attribute_2,
      url: attribute_3
    }
  ) }

  before { allow(Trello::FakeCard).to receive(:schema).and_return(schema) }

  it 'will call register on each attributes' do
    expect(attribute_1).to receive(:register).with(Trello::FakeCard)
    expect(attribute_2).to receive(:register).with(Trello::FakeCard)
    expect(attribute_3).to receive(:register).with(Trello::FakeCard)

    Trello::RegisterAttrs.execute(Trello::FakeCard)
  end

end
