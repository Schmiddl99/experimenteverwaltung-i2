class Link < ApplicationRecord
  belongs_to :experiment
  validates :url, presence: true, url: true
end
