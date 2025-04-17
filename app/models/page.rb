# frozen_string_literal: true

# Page model for the main content pages of the application
# Each page has a title, content, slug, and can belong to a user
class Page < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: nil
  validates :title, presence: true
  validates :slug, uniqueness: true, allow_blank: true
  has_rich_text :content
  scope :published, -> { where(published: true) }
  scope :in_menu, -> { where(is_in_menu: true).order(position: :asc) }

  acts_as_list add_new_at: :bottom, top_of_list: 0

  attribute :is_blog_page, :boolean, default: false
  attribute :is_in_menu, :boolean, default: false

  before_validation :generate_slug, if: :title_changed?
  before_save :handle_menu_position, if: :is_in_menu_changed?

  def to_param
    slug
  end

  private

  def handle_menu_position
    if is_in_menu
      # If the page doesn't have a position yet, add it to the end of the list
      self.position = Page.in_menu.maximum(:position).to_i + 1 if !position || position.zero?
    else
      # If the page is being removed from the menu, reset its position
      self.position = nil
      # Recalculate positions for other pages in the menu
      Page.in_menu.order(:position).each_with_index do |page, index|
        page.update_column(:position, index + 1) if page.position != index + 1
      end
    end
  end

  def generate_slug
    self.slug = title.to_s.parameterize
    # Handle duplicate slugs by adding a number at the end if necessary
    duplicate_check = 1
    original_slug = slug
    while Page.where.not(id: id).exists?(slug: slug)
      self.slug = "#{original_slug}-#{duplicate_check}"
      duplicate_check += 1
    end
  end
end
