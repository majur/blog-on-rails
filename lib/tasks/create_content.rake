# frozen_string_literal: true

namespace :posts do
  desc "Create a new post with given data"
  task :create, [:title, :content, :user_id, :published, :created_at] => :environment do |_, args|
    unless args[:title] && args[:user_id]
      puts "ERROR: Title and user ID are required parameters."
      puts "Usage: rake \"posts:create[title,content,user_id,published,created_at]\"" 
      puts "Example: rake \"posts:create[My first post,This is the content of the post,1,true,2023-10-15 14:30:00]\""
      exit 1
    end

    # Convert string values to boolean
    published = args[:published] == "true" 

    # Find the user
    user = User.find_by(id: args[:user_id])
    unless user
      puts "ERROR: User with ID #{args[:user_id]} was not found."
      exit 1
    end
    
    # Create the post
    post = Post.new(
      title: args[:title],
      user: user,
      published: published
    )

    # Set creation date if provided
    post.created_at = Time.zone.parse(args[:created_at]) if args[:created_at].present?

    # ActionText content is set separately
    post.content = args[:content] if args[:content].present?

    if post.save
      puts "Post was successfully created:"
      puts "ID: #{post.id}"
      puts "Title: #{post.title}"
      puts "Slug: #{post.slug}"
      puts "Author ID: #{post.user_id}"
      puts "Published: #{post.published}"
      puts "Created at: #{post.created_at}"
    else
      puts "ERROR creating post:"
      post.errors.full_messages.each do |message|
        puts "- #{message}"
      end
    end
  end

  desc "Create a sample post for a given user"
  task :create_sample, [:user_id] => :environment do |_, args|
    unless args[:user_id]
      puts "ERROR: User ID is a required parameter."
      puts "Usage: rake \"posts:create_sample[user_id]\""
      puts "Example: rake \"posts:create_sample[1]\""
      exit 1
    end

    Rake::Task["posts:create"].invoke(
      "Sample post", 
      "This is the content of a sample post. You can write your text here.", 
      args[:user_id], 
      "true"
    )
  end
end

namespace :pages do
  desc "Create a new page with given data"
  task :create, [:title, :content, :user_id, :published, :is_blog_page, :is_in_menu] => :environment do |_, args|
    unless args[:title] && args[:user_id]
      puts "ERROR: Title and user ID are required parameters."
      puts "Usage: rake \"pages:create[title,content,user_id,published,is_blog_page,is_in_menu]\""
      puts "Example: rake \"pages:create[About me,This is the content of the page,1,true,false,true]\""
      exit 1
    end

    # Convert string values to boolean
    published = args[:published] == "true"
    is_blog_page = args[:is_blog_page] == "true"
    is_in_menu = args[:is_in_menu] == "true"

    # Find the user
    user = User.find_by(id: args[:user_id])
    unless user
      puts "ERROR: User with ID #{args[:user_id]} was not found."
      exit 1
    end
    
    # Create the page
    page = Page.new(
      title: args[:title],
      user: user,
      published: published,
      is_blog_page: is_blog_page,
      is_in_menu: is_in_menu
    )

    # ActionText content is set separately
    page.content = args[:content] if args[:content].present?

    if page.save
      puts "Page was successfully created:"
      puts "ID: #{page.id}"
      puts "Title: #{page.title}"
      puts "Slug: #{page.slug}"
      puts "Author ID: #{page.user_id}"
      puts "Published: #{page.published}"
      puts "Is blog page: #{page.is_blog_page}"
      puts "Is in menu: #{page.is_in_menu}"
      puts "Menu position: #{page.position}" if page.is_in_menu
    else
      puts "ERROR creating page:"
      page.errors.full_messages.each do |message|
        puts "- #{message}"
      end
    end
  end

  desc "Create basic pages for the blog"
  task :create_basic, [:user_id] => :environment do |_, args|
    unless args[:user_id]
      puts "ERROR: User ID is a required parameter."
      puts "Usage: rake \"pages:create_basic[user_id]\""
      puts "Example: rake \"pages:create_basic[1]\""
      exit 1
    end

    # Create blog page
    Rake::Task["pages:create"].reenable
    Rake::Task["pages:create"].invoke(
      "Blog", 
      "This is a blog page where all posts will be displayed.", 
      args[:user_id], 
      "true",
      "true",
      "true"
    )

    # Create About me page
    Rake::Task["pages:create"].reenable
    Rake::Task["pages:create"].invoke(
      "About me", 
      "This is a page where you can write something about yourself.", 
      args[:user_id], 
      "true",
      "false",
      "true"
    )

    # Create Contact page
    Rake::Task["pages:create"].reenable
    Rake::Task["pages:create"].invoke(
      "Contact", 
      "Here you can provide your contact information.", 
      args[:user_id], 
      "true",
      "false",
      "true"
    )
  end
end

namespace :settings do
  desc "Create or update blog settings"
  task :create, [:blog_name, :registration_enabled] => :environment do |_, args|
    unless args[:blog_name]
      puts "ERROR: Blog name is a required parameter."
      puts "Usage: rake \"settings:create[blog_name,registration_enabled]\""
      puts "Example: rake \"settings:create[My personal blog,true]\""
      exit 1
    end

    # Convert string values to boolean
    registration_enabled = args[:registration_enabled] == "true"
    
    # Try to find existing settings
    setting = Setting.first || Setting.new
    
    # Update settings
    setting.blog_name = args[:blog_name]
    setting.registration_enabled = registration_enabled
    
    if setting.save
      puts "Settings were successfully created/updated:"
      puts "ID: #{setting.id}"
      puts "Blog name: #{setting.blog_name}"
      puts "Registration enabled: #{setting.registration_enabled}"
    else
      puts "ERROR creating/updating settings:"
      setting.errors.full_messages.each do |message|
        puts "- #{message}"
      end
    end
  end

  desc "Create default blog settings"
  task :create_default => :environment do
    Rake::Task["settings:create"].invoke("My personal blog", "false")
  end
end 