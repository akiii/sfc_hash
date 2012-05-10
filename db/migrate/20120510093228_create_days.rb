class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.string :self

      t.timestamps
    end
  end
end
