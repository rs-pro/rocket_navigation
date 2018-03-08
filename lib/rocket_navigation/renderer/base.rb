require 'forwardable'

module RocketNavigation
  module Renderer
    # This is the base class for all renderers.
    #
    # A renderer is responsible for rendering an ItemContainer and its
    # containing items to HTML.
    class Base
      extend Forwardable
      attr_reader :options

      def_delegators :container, :view_context
      def_delegators :view_context, :link_to, :content_tag

      def initialize(container, options)
        @container = container
        @options = options
      end

      def container_html
        @container_html ||= container.container_html.merge(options[:container_html])
      end

      def base_item_html
        @base_item_html ||= container.item_html.merge(options[:item_html])
      end

      def base_link_html
        @base_link_html ||= container.link_html.merge(options[:link_html])
      end

      def selected_class(type)
        container.selected_class[type] || options[:selected_class][type]
      end

      def item_html(item)
        classes = Array.wrap(item[:class] || [])
        if item.selected?
          classes.push(selected_class(:item))
        end
        if item.active_branch?
          classes.push(selected_class(:branch))
        end

        base_item_html.except(:class).merge(class: classes)
      end

      def expand_all?
        !!options[:expand_all]
      end

      def level
        options[:level] || :all
      end

      def skip_if_empty?
        !!options[:skip_if_empty]
      end

      def include_sub_navigation?(item)
        consider_sub_navigation?(item) && expand_sub_navigation?(item)
      end

      def render_sub_navigation_for(item)
        item.sub_navigation.render(options)
      end

      # Renders the specified ItemContainer to HTML.
      #
      # When implementing a renderer, please consider to call
      # include_sub_navigation? to determine whether an item's sub_navigation
      # should be rendered or not.
      def render(item_container)
        fail NotImplementedError, 'subclass responsibility'
      end

      protected

      def consider_sub_navigation?(item)
        return false unless item.sub_navigation

        case level
        when :all then true
        when Range then item.sub_navigation.level <= level.max
        else false
        end
      end

      def expand_sub_navigation?(item)
        expand_all? || item.selected?
      end

      # to allow overriding when there is specific logic determining
      # when a link should not be rendered (eg. breadcrumbs renderer
      # does not render the final breadcrumb as a link when instructed
      # not to do so.)
      def suppress_link?(item)
        item.url.nil?
      end

      # determine and return link or static content depending on
      # item/renderer conditions.
      def tag_for(item)
        if suppress_link?(item)
          content_tag('span', item.name, options_for(item).except(:method))
        else
          link_to(item.name, item.url, options_for(item))
        end
      end

      # Extracts the options relevant for the generated link
      def link_options_for(item)
        options = {
          method: item.method,
          class: item.selected_class
        }.reject { |_, v| v.nil? }

        options.merge!(item.options[:html]) unless item.options[:html].nil?
        options.merge!(class: class_for(item))

        opts
      end
    end
  end
end
