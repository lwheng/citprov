class AddAnnotateCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :annotate_count, :integer
  end
end
