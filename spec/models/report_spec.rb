require 'rails_helper'

describe Report do
  it { expect(subject).to have_db_column(:id) }
  it { expect(subject).to have_db_column(:name) }
  it { expect(subject).to have_db_column(:quantity) }
  it { expect(subject).to have_db_column(:address) }
  it { expect(subject).to have_db_column(:longitude) }
  it { expect(subject).to have_db_column(:latitude) }
  it { expect(subject).to have_db_column(:description) }
  it { expect(subject).to have_db_column(:photo_file_name) }
  it { expect(subject).to have_db_column(:photo_content_type) }
  it { expect(subject).to have_db_column(:photo_file_size) }
  it { expect(subject).to have_db_column(:photo_updated_at) }
  it { expect(subject).to have_db_column(:reported_at) }
  it { expect(subject).to have_db_column(:status) }
  it { expect(subject).to have_db_column(:created_at) }
  it { expect(subject).to have_db_column(:updated_at) }

  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:tracer) }

  it { expect(subject).to validate_presence_of(:tracer_id) }
  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:latitude) }
  it { expect(subject).to validate_presence_of(:longitude) }
  it { expect(subject).to validate_presence_of(:reported_at) }
  it { expect(subject).to validate_presence_of(:photo) }
end
