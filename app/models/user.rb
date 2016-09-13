class User < ActiveRecord::Base

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
  # Это предварительное решение. См. полную реализацию в "Following users".
    Micropost.where("user_id = ?", id)
  end

  def	following?(other_user)
    relationships.find_by(followed_id:	other_user.id)
  end

  def	follow!(other_user)
    relationships.create!(followed_id:	other_user.id)
  end

  def	unfollow!(other_user)
    relationships.find_by(followed_id:	other_user.id).destroy!
  end




  validates :name,  presence: true
  validates :email, presence: true
  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  before_save { self.email = email.downcase }

  has_secure_password

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  has_many :microposts, dependent: :destroy

  has_many	:relationships,	foreign_key:	"follower_id",	dependent:	:destroy
  has_many	:followed_users,	through:	:relationships,	source:	:followed

  # revers relationship for user.followers
  has_many	:reverse_relationships,	foreign_key:	"followed_id",
                                    class_name:		"Relationship",
                                    dependent:			:destroy
  has_many	:followers,	through:	:reverse_relationships,	source:	:follower

end
