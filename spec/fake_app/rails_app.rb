ENV['RAILS_ENV'] ||= 'test'

require 'action_controller/railtie'

module RailsApp
  class Application < Rails::Application
    config.active_support.deprecation = :log
    config.cache_classes = true
    config.eager_load = false
    config.root = __dir__
    config.secret_token = 'x'*100
    config.session_store :cookie_store, key: '_myapp_session'
  end

  class TestsController < ActionController::Base
    def main_nav
      proc do |nav|
        nav.items do |nav|
          nav.item :item_1, 'Item 1', '/item_1', html: {class: 'item_1'}, link_html: {id: 'link_1'}
          nav.item :item_2, 'Item 2', '/item_2', html: {class: 'item_2'}, link_html: {id: 'link_2'}
        end
      end
    end

    def base
      render inline: <<-END
        <!DOCTYPE html>
        <html>
          <body>
            <%= render_navigation &main_nav %>
          </body>
        </html>
      END
    end
  end
end

Rails.backtrace_cleaner.remove_silencers!
RailsApp::Application.initialize!

RailsApp::Application.routes.draw do
  get '/base_spec' => 'rails_app/tests#base'
end
