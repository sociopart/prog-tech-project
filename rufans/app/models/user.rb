class User < ApplicationRecord
  validates_inclusion_of :gender, :in => [true, false]
  enum role: [:user, :seller, :admin]
  after_initialize :set_default_role, :if => :new_record? 
  after_create :set_default_tag, :if => :persisted? 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { within: 8..128 }, on: :create
  validates :password, presence: true,
                      confirmation: true,
                      length: { within: 8..128 },
                      on: :update, allow_nil: true,
                      if: :encrypted_password_changed?
  validates :birthday, presence: true

  has_many :followed_users,
           foreign_key: :follower_id,
           class_name: 'Relationship',
           dependent: :destroy

  has_many :comments, dependent: :destroy

  has_many :followees, through: :followed_users, dependent: :destroy
  
  has_many :following_users,
  foreign_key: :followee_id,
  class_name: 'Relationship',
  dependent: :destroy

  has_many :followers, through: :following_users, dependent: :destroy

  has_many :likeables, dependent: :destroy
  has_many :liked_posts, through: :likeables, source: :post

  has_many :posts
  has_one_attached :avatar

  def liked?(post)
    liked_posts.include?(post)
  end

  def like(post)
    if liked_posts.include?(post)
      liked_posts.destroy(post)
    else
      liked_posts << post
    end
    public_target = "post_#{post.id}_public_likes"
    broadcast_replace_to "public_likes",
                         target: public_target,
                         partial: "likes/like_count",
                         locals: { post: post }
  end

  private
  def set_default_role
    self.role ||= :user
  end
  #есть уязвимость надо переобдумать
  def set_default_tag
    self.update_column(:user_tag, "#{self.id}")
  end
end
