class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :hashtag_id
      t.string :text
      t.string :from_user
      t.string :profile_image_url

      t.timestamps
    end
  end
end
