Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load
  config.action_mailer.delivery_method = :smtp


  config.action_mailer.smtp_settings = {
    :address => "email-smtp.us-west-2.amazonaws.com",
    :port => 587,
    :user_name => ENV["smtp_user"],
    :password => ENV["smtp_password"],
    :authentication => :login,
    :enable_starttls_auto => true
  }
  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true
  CarrierWave.configure do |config|
     config.fog_provider = 'fog/aws'                        # required
     config.fog_credentials = {
       provider:              'AWS',                        # required
       aws_access_key_id:     ENV["aws_access_key_id"],       # required
       aws_secret_access_key: ENV["aws_secret_access_key"],                        # required
       region:                ENV["aws_region"],                  # optional, defaults to 'us-east-1'
     }
     config.fog_directory  = ENV["aws_bucket_name"]                                      # required
     config.fog_public     = true                                                # optional, defaults to true
     config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
  end
  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
