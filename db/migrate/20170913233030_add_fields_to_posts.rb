class AddFieldsToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :forced, :boolean, default: false
    add_column :posts, :relevant_until, :datetime
  end
end
