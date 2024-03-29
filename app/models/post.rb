class Post < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  has_rich_text :content
  scope :published, -> { where(published: true) }
end
