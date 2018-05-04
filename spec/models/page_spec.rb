require 'rails_helper'

describe Page do
  it { expect(subject).to have_db_column(:id) }
  it { expect(subject).to have_db_column(:name) }
  it { expect(subject).to have_db_column(:content) }
  it { expect(subject).to have_db_column(:language) }
  it { expect(subject).to have_db_column(:created_at) }
  it { expect(subject).to have_db_column(:updated_at) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:language) }
  it { expect(subject).to validate_presence_of(:content) }
end
