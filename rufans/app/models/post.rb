class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :likeables, dependent: :destroy
  has_many :likes, through: :likeables, source: :user
  has_many :comments, dependent: :destroy
  def create_post(user, post)
    broadcast_prepend_to(:posts,
                        target: 'posts-block',
                        partial: 'posts/post',
                        locals: {user: nil, post: post, like_status: false})
    broadcast_prepend_to([user, :posts],
                          target: 'posts-block',
                          partial: 'posts/post_owner',
                          locals: {user: user, post: post, like_status: false})
  end

  def update_post(user, post)
    broadcast_replace_to(:posts,
                        target: self,
                        partial: 'posts/post',
                        locals: {user: nil, post: post, like_status: false})
    broadcast_replace_to([user, :posts],
                          target: "post_#{id}",
                          partial: 'posts/post_owner',
                          locals: {user: user, post: post, like_status: user.liked?(post)})
  end

  after_destroy_commit do
    broadcast_remove_to(:posts,
                        target: self
                       )
  end
end
