require 'spec_helper'

RSpec.describe Trello::Card do

  describe '.path_name' do
    specify { expect(Trello::Card.path_name).to eq('card') }
  end

end
