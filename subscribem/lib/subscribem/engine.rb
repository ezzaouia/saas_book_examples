require 'warden'
require 'dynamic_form'

module Subscribem
  class Engine < ::Rails::Engine
    isolate_namespace Subscribem
    
    config.middleware.use Warden::Manager
    
    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end
  end
end
