
def database_inject(db_adapter)
  db_prefix = ask("Database prefix [#{app_name}]: ")
  db_prefix = app_name unless db_prefix.present?
  db_username = ask("Database username [root]: ")
  db_username = "root" unless db_username.present?
  db_password = ask("Database password [<empty>]: ")

  yml_env = File.read("#{$root_directory}/templates/database/#{db_adapter}.yml")
  envs = %w(development test production)
  envs << "staging" if yes_or_blank? "Do you want to include staging environment?"
  yml = ""
  envs.each { |env| yml += yml_env.gsub("database_environment", env) }

  yml.gsub!("database_name", db_prefix)
  yml.gsub!("database_username", db_username)
  yml.gsub!("database_password", db_password)
  create_file("config/database.yml", yml, :force => true)
  append_to_file ".gitignore", "\nconfig/database.yml\n"
end


def database_run
  if yes_or_blank? "Do you want to replace current relational database with preset one?"
    database_types = {postgres: "pg", mysql: "mysql2", sqlite: "sqlite3"}
    database_adapter = ""
    while !database_types.keys.map(&:to_s).include?(database_adapter)
      database_adapter = ask("Choose your database type [#{database_types.keys.join("/")}]")
    end
    gsub_file "Gemfile", /(gem 'sqlite3')|(gem 'mysql')|(gem 'mysql2')|(gem 'pg')/, ""

    gem database_types[database_adapter.to_sym]
    database_inject database_adapter

    rake "db:drop" 
    rake "db:create"
  end
end