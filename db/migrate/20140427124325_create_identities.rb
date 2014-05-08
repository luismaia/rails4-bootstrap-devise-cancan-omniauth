class CreateIdentities < ActiveRecord::Migration
  def change
    create_table(:identities) do |t|
      t.string :uid
      t.string :provider
      t.string :token
      t.string :secret
      t.datetime :expires_at

      t.string :email
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :nickname
      t.string :gender
      t.string :image
      t.date :birthday

      t.references :user
    end
  end
end
