class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :vid
      t.integer :app_user_id
      t.datetime :app_user_created_at
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
