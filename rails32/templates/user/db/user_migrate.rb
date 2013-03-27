class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :password_digest
      t.string :password_recoverable
      t.string :role, :default => "member"
      t.string :auth_token
      t.boolean :locked, :default => false
      t.boolean :activated, :default => false

      t.timestamps
    end
    add_index :users, :email, :unique => true, :null => false
  end
end
