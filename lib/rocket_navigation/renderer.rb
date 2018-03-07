require 'rocket_navigation/helpers'
require 'rocket_navigation/renderer/base'

module RocketNavigation
  module Renderer
    autoload :List, 'rocket_navigation/renderer/list'
    autoload :Links, 'rocket_navigation/renderer/links'
    autoload :Breadcrumbs, 'rocket_navigation/renderer/breadcrumbs'
    autoload :Text, 'rocket_navigation/renderer/text'
    autoload :Json, 'rocket_navigation/renderer/json'
  end
end
