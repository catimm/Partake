Partake
=====

# Development setup

- [Install git](http://git-scm.com/downloads)
- Clone the repo: `git clone git@github.com:catimm/Partake`
- [Install Ruby](https://www.ruby-lang.org/en/downloads/)
 - On Windows, use [RubyInstaller](http://rubyinstaller.org/)
 - Install version 1.9.3
- [Install Ruby DevKit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) for building native extensions
 - The version should match your Ruby version

## Server setup

- Install bundler: `gem install bundler`
- Install rake: `gem install rake`
- Install Postgres
-- On Mac/Linux, follow this page: http://wikimatze.de/installing-postgresql-gem-under-ubuntu-and-mac.html
- On Ubuntu, install SQLite3 development headers `sudo apt-get install libsqlite3-dev` since those development headers will be needed for sqlite gem to install. (sqlite will be needed when doing `bundle install` in next section). See: [this SO question] (http://stackoverflow.com/questions/3458602/sqlite3-ruby-install-error-on-ubuntu?rq=1) for more details
- Under `/web`:
 - Copy `application.yml` received through email to `config/` folder
 - Install dependencies: `bundle install`
 - Create the database: `rake db:create`
 - Ensure the database is up-to-date: `rake db:migrate`

### Running the web server

- Under `/web`:
 - Start the server: `rails s`

### Running the mail server

- Under `/web`:
 - Open a 2nd terminal with: `mailcatcher --ip 127.0.0.1 --smtp-port 25 --http-port 1080`
 - Open webpage at the same location to check mail sent by Partake
 - Note: this is required to be open in order to run any procedure that involves email being sent
 - 
