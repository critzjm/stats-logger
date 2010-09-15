class CreateUserLogs < ActiveRecord::Migration
  def self.up
    create_table :user_log do |t|
      t.integer :user_id
      t.integer :ab_test_id
      t.integer :viral_group_id
      t.string :log_type
      t.text :referrer
      t.text :user_agent
      t.text :path_name
      t.text :query_string
      t.boolean :logged_in
      t.timestamps
    end
    
    add_index :user_log, :log_type
  end

  def self.down
    drop_table :user_log
  end
end
