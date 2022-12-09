class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.belongs_to :post, null: false, foreign_key: :post_id
      t.text :body
      t.belongs_to :user, null: false, foreign_key: :user_id
      
      t.timestamps
    end
  end
end
