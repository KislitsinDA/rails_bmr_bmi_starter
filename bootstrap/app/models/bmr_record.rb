class BmrRecord < ApplicationRecord
  belongs_to :patient
  validates :formula, inclusion: { in: %w[mifflin harris] }
  validates :value, presence: true, numericality: { greater_than: 0 }
end
