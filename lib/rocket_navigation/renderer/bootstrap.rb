# source: https://github.com/pdf/simple-navigation-bootstrap/blob/master/lib/simple_navigation/rendering/renderer/bootstrap.rb
# Copyright (c) 2017 Peter Fern
# MIT License

module RocketNavigation
  module Renderer
    class Bootstrap < RocketNavigation::Renderer::Base
      def initialize(container, options = {})
        super(container, options)
      end

      def render(item_container)
        if skip_if_empty? && item_container.empty?
          ''.html_safe
        else
          if item_container.level > 1
            content = list_content(item_container)
            content_tag(:div, content, {class: "dropdown-menu"})
          else
            tag = options[:ordered] ? :ol : :ul
            content = list_content(item_container)
            content_tag(tag, content, container_html)
          end
        end
      end

      def render_item(item)
        if item.level == 1
          li_content = tag_for(item)
          if include_sub_navigation?(item)
            li_content << render_sub_navigation_for(item)
          end
          content_tag(:li, li_content, item_options(item))
        else
          tag_for(item)
        end
      end

      def list_content(item_container)
        ret = ActiveSupport::SafeBuffer.new
        item_container.items.each do |item|
          ret << render_item(item)
        end
        ret
      end

      def expand_all?
        true
      end
      def consider_sub_navigation?(item)
        return false unless item.sub_navigation
        true
      end

      def item_extra_classes(item)
        if include_sub_navigation?(item)
          ["dropdown"]
        else
          []
        end
      end

      def link_classes(item)
        if item.level > 1
          classes = ["dropdown-item"]
          if item.selected?
            classes.push('active')
          end
          classes
        else
          super(item)
        end
      end

      def tag_for(item)
        if item.level == 1 && item.sub_navigation
          link_to(item.name, item.url, {class: "nav-link dropdown-toggle", 'data-toggle' => "dropdown"})
        else
          super(item)
        end
      end

      def render_sub_navigation_for(item)
        opts = options.dup
        p opts
        item.sub_navigation.render(opts)
      end
    end
  end
end
