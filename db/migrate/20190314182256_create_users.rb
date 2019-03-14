class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :login, null:false
      t.string :encrypted_password, null: false
      t.boolean :admin, default: false
      t.timestamps
    end
    add_index :users, :login
  end
end
