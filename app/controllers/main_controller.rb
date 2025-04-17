# frozen_string_literal: true

# Controller for the main landing page of the application
# Handles rendering the home page and dashboard
class MainController < ApplicationController
  def index
    # Najprv nájdeme prvú stránku z menu, ak existuje
    first_menu_page = Page.in_menu.first
    
    if first_menu_page
      # Nastavíme @page pre view, aby sme mohli použiť šablónu stránky
      @page = first_menu_page
      
      # Ak je to blogová stránka, načítame aj príspevky
      if first_menu_page.is_blog_page
        @posts = Post.published.order(created_at: :desc)
      end
      
      # Použijeme view stránky
      render 'pages/show'
    else
      # Ak neexistuje žiadna stránka v menu, zobrazíme len príspevky
      @posts = Post.published.order(created_at: :desc)
    end
  end
end
