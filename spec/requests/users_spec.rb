require 'rails_helper'

describe 'UsersController', type: :request do
  let(:password) { Faker::Lorem.characters(6) }
  subject! { FactoryBot.create(:user, password: password) }

  describe '#me' do
    let(:request) do
      -> { get me_users_path, headers: headers_with_auth }
    end

    it 'succeeds' do
      request.call
      expect(response.status).to eq 200
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('user')
    end

    context 'when the user is not logged in' do
      let(:request) do
        -> { get me_users_path, headers: headers }
      end

      it 'fails' do
        request.call
        expect(response.status).to eq 401
      end
    end
  end

  describe '#update' do
    let(:request) do
      -> { patch me_users_path, params: parameters.to_json, headers: headers_with_auth }
    end
    let(:parameters) do
      {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        current_password: password
      }
    end

    it 'succeeds' do
      request.call
      expect(response.status).to eq 200
    end

    it 'updates its name' do
      expect { request.call }.to change {
        subject.reload.name
      }.from(subject.name).to(parameters[:name])
    end

    it 'updates the email for the given user' do
      expect { request.call }.to change {
        subject.reload.email
      }.from(subject.email).to(parameters[:email])
    end

    it 'compliances to json-schema' do
      request.call
      expect(response).to match_response_schema('user')
    end

    context 'when the user is not logged in' do
      let(:request) do
        -> { patch me_users_path, params: parameters.to_json, headers: headers }
      end

      it 'fails' do
        request.call
        expect(response.status).to eq 401
      end
    end
  end

  describe '#update_password' do
    subject! { FactoryBot.create(:user, password: current_password) }
    let(:current_password) { Faker::Lorem.characters(6) }
    let(:request) do
      -> { patch update_password_users_path, params: parameters.to_json, headers: headers_with_auth }
    end

    context 'when user provides his previous password successfully' do
      let(:parameters) do
        {
          current_password: current_password,
          password: 'new_password',
          password_confirmation: 'new_password'
        }
      end

      it 'updates his password' do
        request.call
        expect(response.status).to eq 200
      end

      it 'compliances to json-schema' do
        request.call
        expect(response).to match_response_schema('user')
      end
    end

    context 'when user fails to provide his previous password' do
      let(:parameters) do
        {
          current_password: current_password + 'so wrong',
          password: 'new_password',
          password_confirmation: 'new_password'
        }
      end

      it 'fails to update his password' do
        request.call
        expect(response.status).to eq 422
      end
    end

    context 'when user fails to provide the new password twice' do
      let(:parameters) do
        {
          current_password: current_password,
          password: 'new_password',
          password_confirmation: 'new_password_so_wrong'
        }
      end

      it 'fails to update his password' do
        request.call
        expect(response.status).to eq 422
      end
    end

    context 'when the user is not logged in' do
      let(:request) do
        -> { patch update_password_users_path, params: {}.to_json, headers: headers }
      end

      it 'fails' do
        request.call
        expect(response.status).to eq 401
      end
    end
  end

  describe '#destroy' do
    let(:request) do
      -> { delete me_users_path, headers: headers_with_auth }
    end

    it 'succeeds' do
      request.call
      expect(response.status).to eq 204
    end

    it 'deletes the given user' do
      expect { request.call }.to change(User, :count).by(-1)
    end

    context 'when user owns reports' do
      before do
        FactoryBot.create(:report, user: subject)
        FactoryBot.create(:report, user: subject, status: :pending)
        FactoryBot.create(:report, user: subject, status: :pending)
        FactoryBot.create(:report, user: subject, status: :rejected)
      end

      it 'does not remove its reports' do
        expect { request.call }.to_not change(Report, :count)
      end

      it 'renames the reports with the same name' do
        report_ids = subject.reports.pluck(:id)

        request.call
        expect(Report.where(id: report_ids).pluck(:name).uniq.count).to eq(1)
      end
    end

    context 'when the user is not logged in' do
      let(:request) do
        -> { delete me_users_path, headers: headers }
      end

      it 'fails' do
        request.call
        expect(response.status).to eq 401
      end
    end
  end
end
