# frozen_string_literal: true

namespace :posts do
  desc "Vytvorí nový príspevok s danými údajmi"
  task :create, [:title, :content, :user_id, :published] => :environment do |_, args|
    unless args[:title] && args[:user_id]
      puts "CHYBA: Názov a ID používateľa sú povinné parametre."
      puts "Použitie: rake \"posts:create[názov,obsah,user_id,zverejnený]\"" 
      puts "Príklad: rake \"posts:create[Môj prvý príspevok,Toto je obsah príspevku,1,true]\""
      exit 1
    end

    # Konverzia stringových hodnôt na boolean
    published = args[:published] == "true" 

    # Nájdenie používateľa
    user = User.find_by(id: args[:user_id])
    unless user
      puts "CHYBA: Používateľ s ID #{args[:user_id]} nebol nájdený."
      exit 1
    end
    
    # Vytvorenie príspevku
    post = Post.new(
      title: args[:title],
      user: user,
      published: published
    )

    # ActionText obsah sa nastavuje osobitne
    post.content = args[:content] if args[:content].present?

    if post.save
      puts "Príspevok bol úspešne vytvorený:"
      puts "ID: #{post.id}"
      puts "Názov: #{post.title}"
      puts "Slug: #{post.slug}"
      puts "Autor ID: #{post.user_id}"
      puts "Zverejnený: #{post.published}"
    else
      puts "CHYBA pri vytváraní príspevku:"
      post.errors.full_messages.each do |message|
        puts "- #{message}"
      end
    end
  end

  desc "Vytvorí vzorový príspevok pre daného používateľa"
  task :create_sample, [:user_id] => :environment do |_, args|
    unless args[:user_id]
      puts "CHYBA: ID používateľa je povinný parameter."
      puts "Použitie: rake \"posts:create_sample[user_id]\""
      puts "Príklad: rake \"posts:create_sample[1]\""
      exit 1
    end

    Rake::Task["posts:create"].invoke(
      "Vzorový príspevok", 
      "Toto je obsah vzorového príspevku. Tu môžete písať svoj text.", 
      args[:user_id], 
      "true"
    )
  end
end

namespace :pages do
  desc "Vytvorí novú stránku s danými údajmi"
  task :create, [:title, :content, :user_id, :published, :is_blog_page, :is_in_menu] => :environment do |_, args|
    unless args[:title] && args[:user_id]
      puts "CHYBA: Názov a ID používateľa sú povinné parametre."
      puts "Použitie: rake \"pages:create[názov,obsah,user_id,zverejnená,is_blog_page,is_in_menu]\""
      puts "Príklad: rake \"pages:create[O mne,Toto je obsah stránky,1,true,false,true]\""
      exit 1
    end

    # Konverzia stringových hodnôt na boolean
    published = args[:published] == "true"
    is_blog_page = args[:is_blog_page] == "true"
    is_in_menu = args[:is_in_menu] == "true"

    # Nájdenie používateľa
    user = User.find_by(id: args[:user_id])
    unless user
      puts "CHYBA: Používateľ s ID #{args[:user_id]} nebol nájdený."
      exit 1
    end
    
    # Vytvorenie stránky
    page = Page.new(
      title: args[:title],
      user: user,
      published: published,
      is_blog_page: is_blog_page,
      is_in_menu: is_in_menu
    )

    # ActionText obsah sa nastavuje osobitne
    page.content = args[:content] if args[:content].present?

    if page.save
      puts "Stránka bola úspešne vytvorená:"
      puts "ID: #{page.id}"
      puts "Názov: #{page.title}"
      puts "Slug: #{page.slug}"
      puts "Autor ID: #{page.user_id}"
      puts "Zverejnená: #{page.published}"
      puts "Je blogová stránka: #{page.is_blog_page}"
      puts "Je v menu: #{page.is_in_menu}"
      puts "Pozícia v menu: #{page.position}" if page.is_in_menu
    else
      puts "CHYBA pri vytváraní stránky:"
      page.errors.full_messages.each do |message|
        puts "- #{message}"
      end
    end
  end

  desc "Vytvorí základné stránky pre blog"
  task :create_basic, [:user_id] => :environment do |_, args|
    unless args[:user_id]
      puts "CHYBA: ID používateľa je povinný parameter."
      puts "Použitie: rake \"pages:create_basic[user_id]\""
      puts "Príklad: rake \"pages:create_basic[1]\""
      exit 1
    end

    # Vytvorenie blogovej stránky
    Rake::Task["pages:create"].reenable
    Rake::Task["pages:create"].invoke(
      "Blog", 
      "Toto je blogová stránka, kde sa budú zobrazovať všetky príspevky.", 
      args[:user_id], 
      "true",
      "true",
      "true"
    )

    # Vytvorenie stránky O mne
    Rake::Task["pages:create"].reenable
    Rake::Task["pages:create"].invoke(
      "O mne", 
      "Toto je stránka, kde môžete napísať niečo o sebe.", 
      args[:user_id], 
      "true",
      "false",
      "true"
    )

    # Vytvorenie stránky Kontakt
    Rake::Task["pages:create"].reenable
    Rake::Task["pages:create"].invoke(
      "Kontakt", 
      "Tu môžete uviesť svoje kontaktné údaje.", 
      args[:user_id], 
      "true",
      "false",
      "true"
    )
  end
end

namespace :settings do
  desc "Vytvorí alebo aktualizuje nastavenia blogu"
  task :create, [:blog_name, :registration_enabled] => :environment do |_, args|
    unless args[:blog_name]
      puts "CHYBA: Názov blogu je povinný parameter."
      puts "Použitie: rake \"settings:create[názov_blogu,registrácia_povolená]\""
      puts "Príklad: rake \"settings:create[Môj osobný blog,true]\""
      exit 1
    end

    # Konverzia stringových hodnôt na boolean
    registration_enabled = args[:registration_enabled] == "true"
    
    # Pokúsime sa nájsť existujúce nastavenia
    setting = Setting.first || Setting.new
    
    # Aktualizácia nastavení
    setting.blog_name = args[:blog_name]
    setting.registration_enabled = registration_enabled
    
    if setting.save
      puts "Nastavenia boli úspešne vytvorené/aktualizované:"
      puts "ID: #{setting.id}"
      puts "Názov blogu: #{setting.blog_name}"
      puts "Registrácia povolená: #{setting.registration_enabled}"
    else
      puts "CHYBA pri vytváraní/aktualizácii nastavení:"
      setting.errors.full_messages.each do |message|
        puts "- #{message}"
      end
    end
  end

  desc "Vytvorí základné nastavenia blogu"
  task :create_default => :environment do
    Rake::Task["settings:create"].invoke("Môj osobný blog", "false")
  end
end 