# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Web::Application.initialize!

# Fixes SSL Connection Error in Windows execution of Ruby
# Based on fix described at: https://gist.github.com/fnichol/867550
ENV['SSL_CERT_FILE'] = File.expand_path(File.dirname(__FILE__)) + "/lib/assets/cacert.pem"

# set up email
ActionMailer::Base.delivery_method = :smtp
