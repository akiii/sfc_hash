class CreateSyllabusWords < ActiveRecord::Migration
  def change
    create_table :syllabus_words do |t|
      t.string :string
      t.integer :subject_info_id

      t.timestamps
    end
  end
end
