require 'forwardable'

module RocketNavigation
  module Renderer
    # This is the base class for all renderers.
    #
    # A renderer is responsible for rendering an ItemContainer and its
    # containing items to HTML.
    class Base
      extend Forwardable
      attr_reader :container, :options

      def_delegators :container, :view_context
      def_delegators :view_context, :link_to, :content_tag

      def initialize(container, options = {})
        @container = container
        @options = options
      end

      def selected_class(type)
        container.selected_class[type] || (options[:selected_class] || {})[type]
      end

      def container_html
        @container_html ||= container.container_html.merge(options[:container_html] || {})
      end

      # override this method if needed
      def container_options
        container_html
      end

      def base_item_html
        @base_item_html ||= container.item_html.merge(options[:item_html] || {})
      end

      def item_html(item)
        classes = Array.wrap(base_item_html[:class] || [])
        if item.selected?
          classes.push(selected_class(:item))
        end
        if item.active_branch?
          classes.push(selected_class(:branch))
        end

        ret = base_item_html.except(:class)
        classes = classes.reject { |c| c.nil? }
        ret.merge!({class: classes}) unless classes.blank?
        ret
      end

      # override this method if needed
      def item_options(item)
        item_html(item)
      end

      def base_link_html
        @base_link_html ||= container.link_html.merge(options[:link_html] || {})
      end

      def link_html(item)
        classes = Array.wrap(base_link_html[:class] || [])
        if item.selected?
          classes.push(selected_class(:link))
        end
        ret = base_link_html.except(:class)

        ret.merge!({ method: method }) unless item.method.blank?

        classes = classes.reject { |c| c.nil? }
        ret.merge!({class: classes}) unless classes.blank?

        ret
      end

      # override this method if needed
      def link_options(item)
        link_html(item)
      end

      def expand_all?
        !options.key?(:expand_all) || options[:expand_all] == false
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

      def consider_sub_navigation?(item)
        return false unless item.sub_navigation

        case level
        when :all
          true
        when Range
          item.sub_navigation.level <= level.max
        else
          false
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
          suppressed_tag_for(item)
        else
          active_tag_for(item)
        end
      end

      # render an item as a non-active link (span)
      def suppressed_tag_for(item)
        content_tag('span', item.name, link_options(item).except(:method))
      end

      # render an item as an active link (a)
      def active_tag_for(item)
        link_to(item.name, item.url, link_options(item))
      end
    end
  end
end
