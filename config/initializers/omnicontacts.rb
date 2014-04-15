require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, "792040380589.apps.googleusercontent.com", "T5pdDR6WJBe8xdbBpvjAwh72", {:ssl_ca_file => 'lib/ca-bundle.crt'}
  importer :yahoo, "dj0yJmk9ZGJwZ0JheDZkZzl5JmQ9WVdrOWFtODJOVWh3TnpnbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD04ZQ--", "6b5a6ba6172d6902957a14ae07d0a845da340e82", {:ssl_ca_file => 'lib/ca-bundle.crt'}
  importer :hotmail, "000000004C11187A", "BN9NiKWy5NIiFAI7TZBtcbhPcaMBbQyj", {:ssl_ca_file => 'lib/ca-bundle.crt'}
end