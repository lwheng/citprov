class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :annotations, :user, :annotations
    rename_column :annotations, :users_count, :annotation_count
    rename_column :users, :annotate_count, :old_annotation_count
  end

  def down
  end
end
