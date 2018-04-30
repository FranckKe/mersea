class CreateAccessTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :access_tokens, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.belongs_to :user, type: :uuid, null: false, index: true

      t.string :jti, null: false, index: true
      t.string :aud
      t.datetime :exp, null: false

      t.timestamps null: false
    end
  end
end
