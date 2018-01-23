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
