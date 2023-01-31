class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :likeables, dependent: :destroy
  has_many :likes, through: :likeables, source: :user
  has_many :comments, dependent: :destroy

  after_create_commit do
    #for all followers current_user'a
    user.followers.each do |fl|
      broadcast_prepend_to([fl ,:posts],
                          target: 'posts-block',
                          partial: 'posts/post',
                          locals: {user: nil, post: self, like_status: false})
    end
    #for current_user channel
    broadcast_prepend_to([user ,:posts],
                        target: 'posts-block',
                        partial: 'posts/post',
                        locals: {user: user, post: self, like_status: false})
    # broadcast_prepend_to([user, :posts],
    #                       target: 'posts-block',
    #                       partial: 'posts/post_owner',
    #                       locals: {user: user, post: post, like_status: false})
  end

 after_update_commit do
    #кидаем бродкаст всем кто слушает канал :posts,
    #у кого есть соответствующий див блок - поменяется тело поста
    broadcast_replace_to(:posts,
                        target: "body_post_#{id}",
                        partial: 'posts/body',
                        locals: {user: nil, post: self})
    #перерисовываем с нуля у того кто редактировал
    broadcast_replace_to([user, :posts],
                        target: "post_#{id}",
                        partial: 'posts/post',
                        locals: {user: user, post: self, like_status: user.liked?(self)})
    # broadcast_replace_to([user, :posts],
    #                       target: "post_#{id}",
    #                       partial: 'posts/post_owner',
    #                       locals: {user: user, post: post, like_status: user.liked?(post)})
  end

  #кидаем всем на уделение конкретного див блока, у кого есть - удалится
  after_destroy_commit do
    broadcast_remove_to(:posts,
                        target: self
                       )
  end
end
