class Application < ApplicationRecord
    include ActiveModel::Validations
   # Relations
  has_many :chats

  # Validations
  validates :name, presence: true
  validates_uniqueness_of :name, message: "name is already taken"

  after_validation :set_token, on: :create

    private

  def set_token
    self.token = generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.hex(16)
      break token unless Application.exists?(token: token)
    end
  end
end
