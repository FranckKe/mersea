require 'rails_helper'

describe User do
  it { expect(subject).to have_db_column(:id) }
  it { expect(subject).to have_db_column(:name) }
  it { expect(subject).to have_db_column(:email) }
  it { expect(subject).to have_db_column(:encrypted_password) }
  it { expect(subject).to have_db_column(:reset_password_token) }
  it { expect(subject).to have_db_column(:reset_password_sent_at) }
  it { expect(subject).to have_db_column(:remember_created_at) }
  it { expect(subject).to have_db_column(:created_at) }
  it { expect(subject).to have_db_column(:updated_at) }
  it { expect(subject).to have_db_column(:senior) }
  it { expect(subject).to have_db_column(:language) }

  it { expect(subject).to have_many(:reports) }

  it { expect(subject).to validate_presence_of(:email) }
  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:language) }
  it { expect(subject).to validate_presence_of(:password) }
end
