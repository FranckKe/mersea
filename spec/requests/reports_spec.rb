require 'rails_helper'

describe 'ReportsController', type: :request do
  subject!(:report) { FactoryBot.create(:report) }

  describe '#index' do
    before do
      FactoryBot.create(:report)
    end

    context 'when json rendering' do
      let(:request) do
        -> { get reports_path, headers: headers }
      end

      it 'succeeds' do
        request.call
        expect(response.status).to eq 200
      end

      it 'returns two reports' do
        request.call
        expect(JSON.parse(response.body).count).to eq 2
      end

      it 'compliances to json-schema' do
        request.call
        expect(response).to match_response_schema('reports')
      end
    end

    context 'when geojson rendering' do
      let(:request) do
        -> { get reports_path, headers: geojson_headers }
      end

      it 'succeeds' do
        request.call
        expect(response.status).to eq 200
      end

      it 'returns two reports' do
        request.call
        expect(JSON.parse(response.body).count).to eq 2
      end

      it 'compliances to json-schema' do
        request.call
        expect(response).to match_response_schema('geojson-reports')
      end
    end
  end

  describe '#show' do
    context 'when json rendering' do
      let(:request) do
        -> { get report_path(report.id), headers: headers }
      end

      it 'succeeds' do
        request.call
        expect(response.status).to eq 200
      end

      it 'compliances to json-schema' do
        request.call
        expect(response).to match_response_schema('report')
      end
    end

    context 'when geojson rendering' do
      let(:request) do
        -> { get report_path(report.id), headers: geojson_headers }
      end

      it 'succeeds' do
        request.call
        expect(response.status).to eq 200
      end

      it 'compliances to json-schema' do
        request.call
        expect(response).to match_response_schema('geojson-report')
      end
    end
  end

  describe '#create' do
    let(:tracer) { FactoryBot.create(:tracer) }
    let(:parameters) do
      {
        name: 'toto',
        quantity: 42,
        address: 'somewhere',
        longitude: 42,
        latitude: 42.42,
        description: '42',
        reported_at: '2042-12-13',
        tracer_id: tracer.id,
        photo: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAIAAAACDbGyAAAAEElEQVR4AWMQ7d2BjCjlAwA4QCHL+OA2ggAAAABJRU5ErkJggg=='
      }
    end

    context 'when the user is logged in' do
      let(:request) do
        -> { post reports_path, params: parameters.to_json, headers: headers_with_auth }
      end

      context 'when parameters are valid' do
        it 'succeeds' do
          request.call
          expect(response.status).to eq 201
        end

        it 'creates a new report' do
          request.call
          expect { request.call }.to change(Report, :count).by(1)
        end

        it 'compliances to json-schema' do
          request.call
          expect(response).to match_response_schema('report')
        end
      end

      context 'when parameters are invalid' do
        let(:parameters) { {} }

        it 'succeeds' do
          request.call
          expect(response.status).to eq 422
        end

        it 'does not create a new report' do
          request.call
          expect { request.call }.to_not change(Report, :count)
        end
      end
    end

    context 'when the user is not logged in' do
      context 'with reCaptcha' do
        let(:request) do
          -> { post reports_path, params: parameters.to_json, headers: headers }
        end

        before do
          allow_any_instance_of(ReportPolicy).to receive(:verify_recaptcha).and_return(true)
        end

        it 'succeeds' do
          request.call
          expect(response.status).to eq 201
        end

        it 'creates a new report' do
          request.call
          expect { request.call }.to change(Report, :count).by(1)
        end

        it 'compliances to json-schema' do
          request.call
          expect(response).to match_response_schema('report')
        end
      end

      context 'without reCaptcha' do
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
      end
    end
  end

  describe '#update' do
    let(:request) do
      -> { patch report_path(report.id), params: parameters.to_json, headers: headers_with_auth }
    end
    let(:parameters) do
      {
        name: 'toto',
        quantity: 42,
        address: 'somewhere',
        longitude: 42,
        latitude: 42.42,
        description: '42',
        reported_at: '2042-12-13'
      }
    end

    it 'succeeds' do
      request.call
      expect(response.status).to eq 200
    end

    it 'updates the report' do
      request.call
      model = Report.find(report.id)
      expect(model.name).to eq(parameters[:name])
      expect(model.quantity).to eq(parameters[:quantity])
      expect(model.address).to eq(parameters[:address])
      expect(model.longitude).to eq(parameters[:longitude])
      expect(model.latitude).to eq(parameters[:latitude])
      expect(model.description).to eq(parameters[:description])
      expect(model.reported_at.to_time.to_i).to eq(Time.parse(parameters[:reported_at]).to_i)
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('report')
    end

    context 'when the resource is not owned by the user' do
      let(:other_report) { FactoryBot.create(:report) }
      let(:request) do
        -> { delete report_path(other_report.id), headers: headers_with_auth }
      end

      it 'fails' do
        request.call
        expect(response.status).to eq 403
      end
    end

    context 'when the user is not logged in' do
      let(:request) do
        -> { delete report_path(report.id), headers: headers }
      end

      it 'fails' do
        request.call
        expect(response.status).to eq 403
      end
    end
  end

  describe '#destroy' do
    let(:request) do
      -> { delete report_path(report.id), headers: headers_with_auth }
    end

    it 'succeeds' do
      request.call
      expect(response.status).to eq 204
    end

    it 'deletes the given report' do
      expect { request.call }.to change(Report, :count).by(-1)
    end

    context 'when the resource is not owned by the user' do
      let(:other_report) { FactoryBot.create(:report) }
      let(:request) do
        -> { delete report_path(other_report.id), headers: headers_with_auth }
      end

      it 'fails' do
        request.call
        expect(response.status).to eq 403
      end
    end

    context 'when the user is not logged in' do
      let(:request) do
        -> { delete report_path(report.id), headers: headers }
      end

      it 'fails' do
        request.call
        expect(response.status).to eq 403
      end
    end
  end
end
