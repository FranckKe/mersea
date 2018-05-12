require 'rails_helper'

describe Admin do
  it { expect(subject).to have_db_column(:id) }
  it { expect(subject).to have_db_column(:name) }
  it { expect(subject).to have_db_column(:email) }
  it { expect(subject).to have_db_column(:encrypted_password) }
  it { expect(subject).to have_db_column(:reset_password_token) }
  it { expect(subject).to have_db_column(:reset_password_sent_at) }
  it { expect(subject).to have_db_column(:remember_created_at) }
  it { expect(subject).to have_db_column(:created_at) }
  it { expect(subject).to have_db_column(:updated_at) }
end
