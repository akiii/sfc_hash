class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :self
      t.integer :subject_id
      t.integer :teacher_id
      t.integer :room_id
      t.integer :term_id

      t.timestamps
    end
  end
end
