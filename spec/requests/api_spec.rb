require 'rails_helper'

describe 'ApiController', type: :request do
  describe 'internal server error' do
    let(:request) do
      -> { get tracer_path('some_id'), headers: headers }
    end

    before do
      allow(Tracer).to receive(:find).and_raise(StandardError) # Simulate an internal error
    end

    it 'fails' do
      request.call
      expect(response.status).to eq 500
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('error_internal_error')
    end
  end

  describe 'not found' do
    let(:request) do
      -> { get tracer_path('invalid'), headers: headers }
    end

    it 'fails' do
      request.call
      expect(response.status).to eq 404
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('error_record_not_found')
    end
  end

  describe 'bad request' do
    let(:request) do
      -> { get reports_path, params: { r_min_reported_at: '2018-0212' }, headers: headers }
    end

    it 'fails' do
      request.call
      expect(response.status).to eq 400
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('error_bad_request')
    end
  end

  describe 'unprocessable entity' do
    let(:parameters) do
      {
        name: 'toto',
        quantity: 42,
        missing: 'required params',
      }
    end
    let(:request) do
      -> { post reports_path, params: parameters.to_json, headers: headers }
    end

    it 'fails' do
      request.call
      expect(response.status).to eq 422
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('error_unprocessable_entity')
    end
  end

  describe 'not authorized' do
    let(:parameters) do
      {
        name: 'toto',
        quantity: 42,
        address: 'somewhere',
        longitude: 42,
        latitude: 42.42,
        description: '42',
        reported_at: '2042-12-13',
        tracer_id: 'tracer.id',
        photo: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAIAAAACDbGyAAAAEElEQVR4AWMQ7d2BjCjlAwA4QCHL+OA2ggAAAABJRU5ErkJggg=='
      }
    end
    let(:request) do
      -> { post reports_path, params: parameters.to_json, headers: headers }
    end

    before do
      allow_any_instance_of(ReportPolicy).to receive(:verify_recaptcha).and_return(false)
    end

    it 'fails' do
      request.call
      expect(response.status).to eq 403
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('error_not_authorized')
    end
  end
end
