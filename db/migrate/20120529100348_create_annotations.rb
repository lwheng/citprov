class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.string :user
      t.text :citation

      t.timestamps
    end
  end
end
