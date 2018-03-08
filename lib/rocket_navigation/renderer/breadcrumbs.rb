module RocketNavigation
  module Renderer
    # Renders an ItemContainer as a <div> element and its containing items as
    # <a> elements.
    # It only renders 'selected' elements.
    #
    # By default, the renderer sets the item's key as dom_id for the rendered
    # <a> element unless the config option <tt>autogenerate_item_ids</tt> is
    # set to false.
    #
    # The id can also be explicitely specified by setting the id in the
    # html-options of the 'item' method in the config/navigation.rb file.
    # The ItemContainer's dom_attributes are applied to the surrounding <div>
    # element.
    class Breadcrumbs < RocketNavigation::Renderer::Base
      def render(item_container)
        content = ActiveSupport::SafeBuffer.new
        content << prefix_for(content)
        content << a_tags(item_container)
        content_tag(
          :div,
          content,
          container_html
        )
      end

      protected

      def a_tags(item_container)
        list = ActiveSupport::SafeBuffer.new
        item_container.items.each do |item|
          next unless item.selected?
          list << tag_for(item)

          if include_sub_navigation?(item)
            list << join_with
            list << a_tags(item.sub_navigation)
          end
        end
        list
      end

      def join_with
        @join_with ||= options[:join_with] || ' '.html_safe
      end

      def suppress_link?(item)
        super || (options[:static_leaf] && item.active_leaf?)
      end

      def prefix_for(content)
        if !content.empty? && options[:prefix]
          options[:prefix]
        else
          ''
        end
      end
    end
  end
end
