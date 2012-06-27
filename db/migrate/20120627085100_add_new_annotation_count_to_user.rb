class AddNewAnnotationCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :new_annotation_count, :integer
  end
end
