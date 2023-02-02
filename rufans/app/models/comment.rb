class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :comments, foreign_key: :parent_id, dependent: :destroy

  after_create_commit do
    if self.parent_id.nil?
      broadcast_prepend_to(:posts, 
                          target: "comments_post_#{self.post.id}", 
                          partial: "comments/comment", 
                          locals: {comment: self, user: nil, post: post})
      broadcast_prepend_to([user, :posts], 
                          target: "comments_post_#{self.post.id}", 
                          partial: "comments/comment", 
                          locals: {comment: self, user: user, post: post})
    else
      broadcast_prepend_to(:posts, 
                          target: "comment_#{self.parent_id}_with_comments", 
                          partial: "comments/comment", 
                          locals: {comment: self, user: nil, post: post})
      broadcast_prepend_to([user, :posts], 
                          target: "comment_#{self.parent_id}_with_comments", 
                          partial: "comments/comment", 
                          locals: {comment: self, user: user, post: post})
    end
    comment_count()
  end

  after_update_commit do
    broadcast_replace_to(:posts, 
                        target: "body_comment_#{id}", 
                        partial: "comments/body", 
                        locals: {comment: self, user: nil, post: post})
    broadcast_replace_to([user, :posts], 
                        target: "comment_#{id}", 
                        partial: "comments/comment", 
                        locals: {comment: self, user: user, post: post})

  end

  after_destroy_commit do
    broadcast_remove_to(:posts, 
                       target: self)
    comment_count
  end
  
  def comment_count
    broadcast_replace_to(:posts,
                        target: "comments_count_post_#{post.id}",
                        partial: "comments/comment_count",
                        locals: { post: post })
  end
end
