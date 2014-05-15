class AddColumnsToUsers < ActiveRecord::Migration
  def up
    # Remove unique index to email
    remove_index :users, :email

    # Add New columns
    add_column :users, :provider, :string, default: "local"
    add_column :users, :uid, :string

    add_column :users, :name, :string #full name
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :nickname, :string
    add_column :users, :birthday, :date

    add_column :users, :gender, :string

    # Add unique index to email and provider tuple
    add_index :users, [:email, :provider], unique: true


  end

  def down
    # Remove unique index to email and provider tuple
    remove_index :users, [:email, :provider]

    # Remove New columns
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string

    remove_column :users, :name, :string
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
    remove_column :users, :nickname, :string
    remove_column :users, :birthday, :date

    remove_column :users, :gender, :string

    # Add unique index to email
    add_index :users, :email
  end

end
