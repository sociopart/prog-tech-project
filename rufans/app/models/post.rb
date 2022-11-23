class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  broadcasts_to ->(post) { :posts_list }, inserts_by: :prepend, target: 'posts-block'
end
