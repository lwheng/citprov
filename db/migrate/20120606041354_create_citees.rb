class CreateCitees < ActiveRecord::Migration
  def change
    create_table :citees do |t|
      t.string :cited
      t.text :citing

      t.timestamps
    end
  end
end
