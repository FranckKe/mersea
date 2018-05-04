require 'rails_helper'

describe 'PagesController', type: :request do
  subject!(:page) { FactoryBot.create(:page) }

  describe '#index' do
    before do
      FactoryBot.create(:page)
    end

    let(:request) do
      -> { get pages_path, headers: headers }
    end

    it 'succeeds' do
      request.call
      expect(response.status).to eq 200
    end

    it 'returns two pages' do
      request.call
      expect(JSON.parse(response.body).count).to eq 2
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('pages')
    end
  end

  describe '#show' do
    let(:request) do
      -> { get page_path(page.id), headers: headers }
    end

    it 'succeeds' do
      request.call
      expect(response.status).to eq 200
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('page')
    end
  end

  describe '#leaderboard' do
    before do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      FactoryBot.create(:user)
      FactoryBot.create(:report, user: user1)
      FactoryBot.create(:report, user: user2)
    end

    let(:request) do
      -> { get leaderboard_path, headers: headers }
    end

    it 'succeeds' do
      request.call
      expect(response.status).to eq 200
    end

    it 'returns two entries' do
      request.call
      expect(JSON.parse(response.body).count).to eq 2
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('leaderboard')
    end
  end
end
