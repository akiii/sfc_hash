class CreateSubjectInfos < ActiveRecord::Migration
  def change
    create_table :subject_infos do |t|
      t.integer :term_id
      t.integer :day_id
      t.integer :timetable_id
      t.integer :room_id
      t.integer :subject_id
      t.integer :teacher_id

      t.timestamps
    end
  end
end
