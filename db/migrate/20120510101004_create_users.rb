class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login_name
      t.string :user_name
      t.string :session_id

      t.timestamps
    end
  end
end
