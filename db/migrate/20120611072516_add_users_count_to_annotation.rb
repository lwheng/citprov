class AddUsersCountToAnnotation < ActiveRecord::Migration
  def change
    add_column :annotations, :users_count, :integer
  end
end
