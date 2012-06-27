class AddAnnotationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :annotations, :text
  end
end
