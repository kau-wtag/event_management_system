require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EventManagementSystem
  class Application < Rails::Application
    config.load_defaults 7.1

    config.i18n.available_locales = [:en, :es]
    config.i18n.default_locale = :es
    config.i18n.fallbacks = [:en] 

    config.autoload_lib(ignore: %w(assets tasks))
    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
