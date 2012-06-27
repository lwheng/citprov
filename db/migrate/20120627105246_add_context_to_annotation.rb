class AddContextToAnnotation < ActiveRecord::Migration
  def change
    add_column :annotations, :context, :text
  end
end
