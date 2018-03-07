module RocketNavigation
  class Railtie < ::Rails::Railtie
    initializer 'rocket_navigation.init' do |app|
      RocketNavigation.init
    end
  end
end
