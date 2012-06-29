class AddMd5ToUser < ActiveRecord::Migration
  def change
    add_column :users, :md5, :text
  end
end
