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
- Under `/web`:
 - Copy `application.yml` received through email to `config/` folder
 - Install dependencies: `bundle install`
 - Create the database: `rake db:create`
 - Ensure the database is up-to-date: `rake db:migrate`

### Running the server

- Under `/web`:
 - Start the server: `rails s`


