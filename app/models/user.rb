class User < ApplicationRecord
  validates_inclusion_of :gender, :in => [true, false]
  enum role: [:user, :seller, :admin]
  after_initialize :set_default_role, :if => :new_record? 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one :userprofile
  has_many :items, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_inclusion_of :gender, :in => [true, false]
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { within: 8..128 }, on: :create
  validates :password, presence: true,
                      confirmation: true,
                      length: { within: 8..128 },
                      on: :update, allow_nil: true,
                      if: :encrypted_password_changed?
  validates :birthday, presence: true

  def set_default_role
    self.role ||= :user
  end
end
