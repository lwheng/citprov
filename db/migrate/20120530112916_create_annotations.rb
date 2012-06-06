class CreateAnnotations < ActiveRecord::Migration
  def up
    create_table :annotations do |t|
      t.string :cite_key
      t.text :user
  
      t.timestamps
    end
  end
end
