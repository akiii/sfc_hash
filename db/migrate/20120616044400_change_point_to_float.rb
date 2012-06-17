class ChangePointToFloat < ActiveRecord::Migration
  def up
    change_column :hashtag_candidates, :point, :float
  end

  def down
    change_column :hashtag_candidates, :point, :integer
  end
end
