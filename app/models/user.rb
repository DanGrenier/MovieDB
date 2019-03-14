class User < ApplicationRecord
  include BCrypt
  validates :login, presence: true, uniqueness: true
  validates :password, presence:true
  has_many :movie_scores, dependent: :destroy
  has_one :access_token, dependent: :destroy

  def password
    @password ||= Password.new(encrypted_password) if encrypted_password.present?
  end

   def password=(new_password)
  	return @password = new_password if new_password.blank?
  	@password = Password.create(new_password)
  	self.encrypted_password = @password
   end
end