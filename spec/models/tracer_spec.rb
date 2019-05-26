require 'rails_helper'

describe Tracer do
  it { expect(subject).to have_db_column(:id) }
  it { expect(subject).to have_db_column(:name) }
  it { expect(subject).to have_db_column(:description) }
  it { expect(subject).to have_db_column(:origin) }
  it { expect(subject).to have_db_column(:kind) }
  it { expect(subject).to have_db_column(:category) }
  it { expect(subject).to have_db_column(:longitude) }
  it { expect(subject).to have_db_column(:latitude) }
  it { expect(subject).to have_db_column(:color) }
  it { expect(subject).to have_db_column(:created_at) }
  it { expect(subject).to have_db_column(:updated_at) }

  it { expect(subject).to have_many(:reports) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:description) }
  # it { expect(subject).to validate_presence_of(:photo) } TODO shoulda-matchers are not compatible with ActiveStorage yet
  it { expect(subject).to validate_presence_of(:origin) }
  it { expect(subject).to validate_presence_of(:kind) }
end
