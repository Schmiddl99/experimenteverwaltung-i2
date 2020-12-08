class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :timeoutable, authentication_keys: [:username]

  has_many :experiments, dependent: :nullify
  validates :name, presence: true
  validates :username, presence: true
  validates :role, presence: true

  enum role: [:guest, :lecturer, :assistant, :admin]

  def active_for_authentication?
    super && active?
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  # use this instead of email_changed? for Rails = 5.1.x
  def will_save_change_to_email?
    false
  end

  def inactive_message
    "Benutzer wurde gesperrt, bitte kontaktieren Sie den Admin."
  end
end
