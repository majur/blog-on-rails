# frozen_string_literal: true

# Model representing static pages in the application
# Each page has a title, content, slug for friendly URLs and a published status
class Page < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :slug, uniqueness: true, allow_blank: true
  has_rich_text :content
  scope :published, -> { where(published: true) }

  attribute :is_blog_page, :boolean, default: false

  before_validation :generate_slug, if: :title_changed?

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = title.to_s.parameterize
    # Handle duplicate slugs by adding a number at the end if necessary
    original_slug = slug
    counter = 2
    while Page.where(slug: slug).where.not(id: id).exists?
      self.slug = "#{original_slug}-#{counter}"
      counter += 1
    end
  end
end
