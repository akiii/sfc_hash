class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :season

      t.timestamps
    end
  end
end
