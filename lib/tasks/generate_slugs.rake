namespace :slugs do
  desc "Generate slugs for existing pages and posts"
  task generate: :environment do
    puts "Generating slugs for Pages..."
    
    Page.find_each do |page|
      if page.slug.blank?
        page.title_will_change! # Trigger the before_validation :generate_slug callback
        page.save
        puts "Generated slug for Page ##{page.id}: #{page.slug}"
      end
    end
    
    puts "Generating slugs for Posts..."
    
    Post.find_each do |post|
      if post.slug.blank?
        post.title_will_change! # Trigger the before_validation :generate_slug callback
        post.save
        puts "Generated slug for Post ##{post.id}: #{post.slug}"
      end
    end
    
    puts "Done!"
  end
end 