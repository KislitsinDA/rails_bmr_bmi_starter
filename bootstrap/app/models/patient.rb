class Patient < ApplicationRecord
  has_many :doctor_patients, dependent: :destroy
  has_many :doctors, through: :doctor_patients
  has_many :bmr_records, dependent: :destroy

  validates :first_name, :last_name, :birthday, presence: true
  validates :gender, inclusion: { in: %w[male female other], allow_nil: true }
  validates :height, numericality: { greater_than: 0 }, allow_nil: true
  validates :weight, numericality: { greater_than: 0 }, allow_nil: true

  validates :first_name, uniqueness: { scope: [:last_name, :middle_name, :birthday], message: "duplicate person for same name and birthday" }
end
