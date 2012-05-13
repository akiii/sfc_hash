class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :string
      t.integer :subject_info_id

      t.timestamps
    end
  end
end
