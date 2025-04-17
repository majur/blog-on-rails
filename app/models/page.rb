# frozen_string_literal: true

# Model representing static pages in the application
# Each page has a title, content, slug for friendly URLs and a published status
class Page < ApplicationRecord
  belongs_to :user
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
      # Ak stránka ešte nemá pozíciu, pridáme ju na koniec zoznamu
      if !position || position.zero?
        self.position = Page.in_menu.maximum(:position).to_i + 1
      end
    else
      # Ak sa stránka odstraňuje z menu, vynulujeme jej pozíciu
      self.position = nil
      # Prepočítame pozície ostatných stránok v menu
      Page.in_menu.order(:position).each_with_index do |page, index|
        page.update_column(:position, index + 1) if page.position != index + 1
      end
    end
  end

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
