# frozen_string_literal: true

namespace :users do
  desc "Vytvorí nového používateľa s danými údajmi"
  task :create, [:email, :name, :password, :superadmin, :author] => :environment do |_, args|
    # Kontrola povinných parametrov
    unless args[:email] && args[:password]
      puts "CHYBA: E-mail a heslo sú povinné parametre."
      puts "Použitie: rake users:create[email,name,password,superadmin,author]"
      puts "Príklad: rake \"users:create[admin@example.com,Admin,tajneheslo,true,true]\""
      exit 1
    end

    # Konverzia stringových hodnôt na boolean
    superadmin = args[:superadmin] == "true"
    author = args[:author] == "true"
    
    # Vytvorenie používateľa
    user = User.new(
      email: args[:email],
      name: args[:name],
      password: args[:password],
      password_confirmation: args[:password],
      superadmin: superadmin,
      author: author
    )

    if user.save
      puts "Používateľ bol úspešne vytvorený:"
      puts "ID: #{user.id}"
      puts "Email: #{user.email}"
      puts "Meno: #{user.name}"
      puts "Superadmin: #{user.superadmin}"
      puts "Autor: #{user.author}"
    else
      puts "CHYBA pri vytváraní používateľa:"
      user.errors.full_messages.each do |message|
        puts "- #{message}"
      end
    end
  end

  desc "Vytvorí administrátora s predvolenými hodnotami"
  task :create_admin, [:email, :password] => :environment do |_, args|
    unless args[:email] && args[:password]
      puts "CHYBA: E-mail a heslo sú povinné parametre."
      puts "Použitie: rake users:create_admin[email,password]"
      puts "Príklad: rake \"users:create_admin[admin@example.com,tajneheslo]\""
      exit 1
    end

    Rake::Task["users:create"].invoke(args[:email], "Administrator", args[:password], "true", "true")
  end
end 