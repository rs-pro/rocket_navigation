module RocketNavigation
  class Railtie < ::Rails::Railtie
    initializer 'rocket_navigation.init' do |app|
      RocketNavigation.init

      ActionController::Base.send(:include, RocketNavigation::Helpers)
      RocketNavigation::Helpers.instance_methods.each do |m|
        ActionController::Base.send(:helper_method, m.to_sym)
      end
    end
  end
end
