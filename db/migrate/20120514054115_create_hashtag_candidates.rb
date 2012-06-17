class CreateHashtagCandidates < ActiveRecord::Migration
  def change
    create_table :hashtag_candidates do |t|
      t.string :string
      t.integer :subject_info_id
      t.float :point

      t.timestamps
    end
  end
end
