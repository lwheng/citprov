class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|
      t.string :name
      t.string :downloadlink

      t.timestamps
    end
  end
end