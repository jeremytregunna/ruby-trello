# Specs covering the members namespace in the Trello API

require 'spec_helper'

module Trello
  describe Member do
    include Helpers

    before(:all) do
      Client.public_key = 'dummy'
      Client.secret     = 'dummy'
    end

    before(:each) do
      stub_oauth!
      @member = Member.find('me')
    end

    context "actions" do
      # This spec needs a better name
      it "retrieves a list of actions"
    end

    context "boards" do
      it "has a list of boards" do
        stub_request(:get, "https://api.trello.com/1/members/me/boards/all?").
          with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
          to_return(:status => 200, :headers => {}, :body => boards_payload)

        boards = @member.boards
        boards.count.should be > 0
      end
    end

    context "organizations" do
      it "has a list of organizations" do
        stub_request(:get, "https://api.trello.com/1/members/me/organizations/all?").
          with(:headers => {'Accept'=>'*/*', 'Authorization'=>/.*/, 'User-Agent' => /.*/}).
          to_return(:status => 200, :headers => {}, :body => orgs_payload)

        orgs = @member.organizations
        orgs.count.should be > 0
      end
    end

    context "personal" do
      it "gets the members bio" do
        @member.bio.should_not be_nil
      end

      it "gets the full name" do
        @member.full_name.should_not be_nil
      end

      it "gets the gravatar id" do
        @member.gravatar_id.should_not be_nil
      end

      it "gets the url" do
        @member.url.should_not be_nil
      end

      it "gets the username" do
        @member.username.should_not be_nil
      end
    end
  end
end