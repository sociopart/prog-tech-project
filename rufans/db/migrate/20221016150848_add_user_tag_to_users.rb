class AddUserTagToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_tag, :string, uniqueness: true
  end
end
