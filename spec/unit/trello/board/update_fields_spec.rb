require 'spec_helper'

RSpec.describe 'Trello::Board#update_fields' do

  let(:board_params) { {
    'id' => '5e93ba403f1ab3603ba81a09',
    'name' => 'IT 1',
    'desc' => 'This is a test board called IT 1',
    'descData' => { 'emoji': {} },
    'closed' => false,
    'idOrganization' => "5e93ba154634282b6df23bcc",
    'idEnterprise' => nil,
    'pinned' => false,
    'url' => 'https://trello.com/b/0zx7ive1/it-1',
    'shortUrl' => 'https://trello.com/b/0zx7ive1',
    'prefs' => {
      'permissionLevel' => 'org',
      'voting' => 'disabled',
      'comments' => 'members',
      'invitations' => 'members',
      'selfJoin' => true,
      'cardCovers' => true,
      'cardAging' => 'regular',
      'background' => 'blue' ,
      'backgroundImage' => nil
    }
   } }

  let(:board) { Trello::Board.new(board_params) }

  context 'when the fields argument is empty' do
    let(:fields) { {} }

    it 'board does not set any fields' do
      board.update_fields(fields)

      expect(board.changed?).to be_falsy
      expect(board.id).to eq(board_params['id'])
      expect(board.name).to eq(board_params['name'])
      expect(board.description).to eq(board_params['desc'])
      expect(board.description_data).to match_hash_with_indifferent_access(board_params['descData'])
      expect(board.closed).to eq(board_params['closed'])
      expect(board.organization_id).to eq(board_params['idOrganization'])
      expect(board.enterprise_id).to eq(board_params['idEnterprise'])
      expect(board.pinned).to eq(board_params['pinned'])
      expect(board.url).to eq(board_params['url'])
      expect(board.short_url).to eq(board_params['shortUrl'])
      expect(board.visibility_level).to eq(board_params['prefs']['permissionLevel'])
      expect(board.voting_permission_level).to eq(board_params['prefs']['voting'])
      expect(board.comment_permission_level).to eq(board_params['prefs']['comments'])
      expect(board.invitation_permission_level).to eq(board_params['prefs']['invitations'])
      expect(board.enable_self_join).to eq(board_params['prefs']['selfJoin'])
      expect(board.enable_card_covers).to eq(board_params['prefs']['cardCovers'])
      expect(board.card_aging_type).to eq(board_params['prefs']['cardAging'])
      expect(board.background_color).to eq(board_params['prefs']['background'])
      expect(board.background_image).to eq(board_params['prefs']['backgroundImage'])
    end
  end

  context 'when the fields argument has at least one field' do

    context 'and the field does changed' do
      let(:fields) { { description: 'Awesome things have changed.' } }

      it 'board does set the changed fields' do
        board.update_fields(fields)

        expect(board.description).to eq('Awesome things have changed.')
      end

      it 'board has been mark as changed' do
        board.update_fields(fields)

        expect(board.changed?).to be_truthy
      end
    end

    context "and the field doesn't changed" do
      let(:fields) { { desc: board_params['desc'] } }

      it "board attributes doesn't changed" do
        board.update_fields(fields)

        expect(board.description).to eq(board_params['desc'])
      end

      it "board hasn't been mark as changed" do
        board.update_fields(fields)

        expect(board.changed?).to be_falsy
      end
    end

    context "and the field isn't a correct attributes of the card" do
      let(:fields) { { abc: 'abc' } }

      it "card attributes doesn't changed" do
        board.update_fields(fields)

        expect(board.id).to eq(board_params['id'])
        expect(board.name).to eq(board_params['name'])
        expect(board.description).to eq(board_params['desc'])
        expect(board.description_data).to match_hash_with_indifferent_access(board_params['descData'])
        expect(board.closed).to eq(board_params['closed'])
        expect(board.organization_id).to eq(board_params['idOrganization'])
        expect(board.enterprise_id).to eq(board_params['idEnterprise'])
        expect(board.pinned).to eq(board_params['pinned'])
        expect(board.url).to eq(board_params['url'])
        expect(board.short_url).to eq(board_params['shortUrl'])
        expect(board.visibility_level).to eq(board_params['prefs']['permissionLevel'])
        expect(board.voting_permission_level).to eq(board_params['prefs']['voting'])
        expect(board.comment_permission_level).to eq(board_params['prefs']['comments'])
        expect(board.invitation_permission_level).to eq(board_params['prefs']['invitations'])
        expect(board.enable_self_join).to eq(board_params['prefs']['selfJoin'])
        expect(board.enable_card_covers).to eq(board_params['prefs']['cardCovers'])
        expect(board.card_aging_type).to eq(board_params['prefs']['cardAging'])
        expect(board.background_color).to eq(board_params['prefs']['background'])
        expect(board.background_image).to eq(board_params['prefs']['backgroundImage'])
      end

      it "card hasn't been mark as changed" do
        board.update_fields(fields)

        expect(board.changed?).to be_falsy
      end
    end
  end

end
