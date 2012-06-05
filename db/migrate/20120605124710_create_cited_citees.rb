class CreateCitedCitees < ActiveRecord::Migration
  def change
    create_table :cited_citees do |t|
      t.string :cited
      t.string :citees

      t.timestamps
    end
  end
end
