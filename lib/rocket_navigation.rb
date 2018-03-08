require "rocket_navigation/version"

# cherry picking active_support stuff
require 'active_support/core_ext/array'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/module/attribute_accessors'

require 'rocket_navigation/configuration'
require 'rocket_navigation/item'
require 'rocket_navigation/item_container'
require 'rocket_navigation/renderer'

if defined?(Rails)
  require "rocket_navigation/railtie"
end

module RocketNavigation
  mattr_accessor :default_renderer
  mattr_accessor :registered_renderers

  self.default_renderer = :list

  self.registered_renderers = {
    list:                 RocketNavigation::Renderer::List,
    links:                RocketNavigation::Renderer::Links,
    breadcrumbs:          RocketNavigation::Renderer::Breadcrumbs,
    breadcrumbs_on_rails: RocketNavigation::Renderer::BreadcrumbsOnRails,
    text:                 RocketNavigation::Renderer::Text,
    json:                 RocketNavigation::Renderer::Json
  }
end

