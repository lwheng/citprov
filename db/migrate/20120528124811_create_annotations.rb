class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.string :matric
      t.string :content

      t.timestamps
    end
  end
end
