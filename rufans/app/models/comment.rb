class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :comments, foreign_key: :parent_id

  after_create_commit do
    if self.parent_id.nil?
      broadcast_prepend_to :posts, target: "comments_post_#{self.post.id}", partial: "comments/comment", locals: {comment: self}
    else
      broadcast_prepend_to :posts, target: "comment_#{self.parent_id}_with_comments", partial: "comments/comment", locals: {comment: self}
    end
  end

  
end
