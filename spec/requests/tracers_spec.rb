require 'rails_helper'

describe 'TracersController', type: :request do
  subject!(:tracer) { FactoryBot.create(:tracer) }

  describe '#index' do
    before do
      FactoryBot.create(:tracer)
    end

    let(:request) do
      -> { get tracers_path, headers: headers }
    end

    it 'succeeds' do
      request.call
      expect(response.status).to eq 200
    end

    it 'returns two tracers' do
      request.call
      expect(JSON.parse(response.body).count).to eq 2
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('tracers')
    end
  end

  describe '#show' do
    let(:request) do
      -> { get tracer_path(tracer.id), headers: headers }
    end

    it 'succeeds' do
      request.call
      expect(response.status).to eq 200
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('tracer')
    end
  end
end
