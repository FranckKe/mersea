require 'rails_helper'

describe AccessToken do
  it { expect(subject).to have_db_column(:id) }
  it { expect(subject).to have_db_column(:jti) }
  it { expect(subject).to have_db_column(:aud) }
  it { expect(subject).to have_db_column(:exp) }
  it { expect(subject).to have_db_column(:created_at) }
  it { expect(subject).to have_db_column(:updated_at) }

  it { expect(subject).to belong_to(:user) }
end
