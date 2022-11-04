class UserProfile < ActiveRecord::Migration[7.0]
  def change
    create_table :user_profiles do |t|
      t.belongs_to :user, foreign_key: :user_id
      t.string :profile_name
      t.text :description
      t.boolean :talant
      #t.string :profilepic
      t.timestamps
    end
  end
end
