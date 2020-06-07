require 'spec_helper'

RSpec.describe 'Trello::Board#new' do

  let(:board) { Trello::Board.new(data) }

  describe 'parse #id (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'id' => '5e93ba98614ac22d22f085c4' } }

      it "parse from data['id']" do
        expect(board.id).to eq('5e93ba98614ac22d22f085c4')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { id: '5e93ba98614ac22d22f085c4' } }

      it 'parse from data[:id]' do
        expect(board.id).to eq('5e93ba98614ac22d22f085c4')
      end
    end
  end

  describe 'parse #name (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'name' => 'Board Name' } }

      it "parse from data['name']" do
        expect(board.name).to eq('Board Name')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { name: 'Board Name' } }

      it 'parse from data[:name]' do
        expect(board.name).to eq('Board Name')
      end
    end
  end

  describe 'parse #description (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'desc' => 'Board Name' } }

      it "parse from data['desc']" do
        expect(board.description).to eq('Board Name')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { desc: 'Board Name' } }

      it 'parse from data[:desc]' do
        expect(board.description).to eq('Board Name')
      end
    end
  end

  describe 'parse #description_data (readonly)' do
    context 'with Trello API respone data' do
      let(:data) { { 'descData' => 'description data...' } }

      it "parse from data['descData']" do
        expect(board.description_data).to eq('description data...')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { description_data: 'description data...' } }

      it "won't parse from data[:description_data]" do
        expect(board.description_data).to eq(nil)
      end
    end
  end

  describe 'parse #closed (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'closed' => true } }

      it "parse from data['closed']" do
        expect(board.closed).to eq(true)
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { closed: true } }

      it 'parse from data[:description_data]' do
        expect(board.closed).to eq(true)
      end
    end
  end

  describe 'parse #organization_id (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'idOrganization' => 'abc123' } }

      it "parse from data['idOrganization']" do
        expect(board.organization_id).to eq('abc123')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { organization_id: 'abc123' } }

      it 'parse from data[:description_data]' do
        expect(board.organization_id).to eq('abc123')
      end
    end
  end

  describe 'parse #enterprise_id (readonly)' do
    context 'with Trello API respone data' do
      let(:data) { { 'idEnterprise' => 'abc123' } }

      it "parse from data['idEnterprise']" do
        expect(board.enterprise_id).to eq('abc123')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { enterprise_id: 'abc123' } }

      it "won't parse from data[:enterprise_id]" do
        expect(board.enterprise_id).to eq(nil)
      end
    end
  end

  describe 'parse #pinned (readonly)' do
    context 'with Trello API respone data' do
      let(:data) { { 'pinned' => false } }

      it "parse from data['pinned']" do
        expect(board.pinned).to eq(false)
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { pinned: false } }

      it "won't parse from data[:pinned]" do
        expect(board.pinned).to eq(false)
      end
    end
  end

  describe 'parse #url (readonly)' do
    context 'with Trello API respone data' do
      let(:data) { { 'url' => 'https://trello.com/b/y1TF9GTa/board-1' } }

      it "parse from data['url']" do
        expect(board.url).to eq('https://trello.com/b/y1TF9GTa/board-1')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { url: 'https://trello.com/b/y1TF9GTa/board-1' } }

      it "won't parse from data[:url]" do
        expect(board.url).to eq('https://trello.com/b/y1TF9GTa/board-1')
      end
    end
  end

  describe 'parse #short_url (readonly)' do
    context 'with Trello API respone data' do
      let(:data) { { 'shortUrl' => 'https://trello.com/b/y1TF9GTa' } }

      it "parse from data['shortUrl']" do
        expect(board.short_url).to eq('https://trello.com/b/y1TF9GTa')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { short_url: 'https://trello.com/b/y1TF9GTa' } }

      it "won't parse from data[:short_url]" do
        expect(board.short_url).to eq(nil)
      end
    end
  end

  #   it "parse #label_names from response['labelNames']" do
  #   end

  describe 'parse #visibility_level (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'prefs' => { 'permissionLevel' => 'org' } } }

      it "parse from data['prefs']['permissionLevel']" do
        expect(board.visibility_level).to eq('org')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { visibility_level: 'org' } }

      it 'parse from data[:visibility_level]' do
        expect(board.visibility_level).to eq('org')
      end
    end
  end

  describe 'parse #voting_permission_level (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'prefs' => { 'voting' => 'org' } } }

      it "parse from data['prefs']['voting']" do
        expect(board.voting_permission_level).to eq('org')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { voting_permission_level: 'org' } }

      it 'parse from data[:voting_permission_level]' do
        expect(board.voting_permission_level).to eq('org')
      end
    end
  end

  describe 'parse #comment_permission_level (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'prefs' => { 'comments' => 'org' } } }

      it "parse from data['prefs']['comments']" do
        expect(board.comment_permission_level).to eq('org')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { comment_permission_level: 'org' } }

      it 'parse from data[:voting_permission_level]' do
        expect(board.comment_permission_level).to eq('org')
      end
    end
  end

  describe 'parse #invitation_permission_level (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'prefs' => { 'invitations' => 'org' } } }

      it "parse from data['prefs']['invitations']" do
        expect(board.invitation_permission_level).to eq('org')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { invitation_permission_level: 'org' } }

      it 'parse from data[:invitation_permission_level]' do
        expect(board.invitation_permission_level).to eq('org')
      end
    end
  end

  describe 'parse #enable_self_join (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'prefs' => { 'selfJoin' => true } } }

      it "parse from data['prefs']['selfJoin']" do
        expect(board.enable_self_join).to eq(true)
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { enable_self_join: true } }

      it 'parse from data[:enable_self_join]' do
        expect(board.enable_self_join).to eq(true)
      end
    end
  end

  describe 'parse #enable_card_covers (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'prefs' => { 'cardCovers' => true } } }

      it "parse from data['prefs']['cardCovers']" do
        expect(board.enable_card_covers).to eq(true)
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { enable_card_covers: true } }

      it 'parse from data[:enable_card_covers]' do
        expect(board.enable_card_covers).to eq(true)
      end
    end
  end

  describe 'parse #background_color (writable)' do
    context 'with Trello API respone data' do
      context 'when using default background' do
        let(:data) { { 'prefs' => { 'background' => 'blue' } } }

        it "parse from data['prefs']['background']" do
          expect(board.background_color).to eq('blue')
        end
      end

      context 'when using a cutom backgroud' do
        let(:data) { { 'prefs' => { 'background' => 'abc123' } } }

        it "parse from data['prefs']['background'] and return nil" do
          expect(board.background_color).to eq(nil)
        end
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { background_color: 'blue' } }

      it 'parse from data[:background_color]' do
        expect(board.background_color).to eq('blue')
      end
    end
  end

  describe 'parse #background_image (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'prefs' => { 'backgroundImage' => 'https://image_url' } } }

      it "parse from data['prefs']['background']" do
        expect(board.background_image).to eq('https://image_url')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { background_image: 'https://image_url' } }

      it 'parse from data[:background_image]' do
        expect(board.background_image).to eq('https://image_url')
      end
    end
  end

  describe 'parse #card_aging_type (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'prefs' => { 'cardAging' => 'pirate' } } }

      it "parse from data['prefs']['cardAging']" do
        expect(board.card_aging_type).to eq('pirate')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { card_aging_type: 'pirate' } }

      it 'parse from data[:card_aging_type]' do
        expect(board.card_aging_type).to eq('pirate')
      end
    end
  end

  describe 'parse #prefs (readonly)' do
    context 'with Trello API respone data' do
      let(:data) { { 'prefs' => { 'permissionLevel' => 'org' } } }

      it "parse from data['prefs']" do
        expect(board.prefs).to eq({ 'permissionLevel' => 'org' })
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { prefs: { 'permissionLevel' => 'org' } } }

      it 'will parse from data[:prefs]' do
        expect(board.prefs).to eq({ 'permissionLevel' => 'org' })
      end
    end
  end

end
