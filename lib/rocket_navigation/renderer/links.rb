module RocketNavigation
  module Renderer
    # Renders an ItemContainer as a <div> element and its containing items as
    # <a> elements.
    # It adds the 'selected' class to the <a> element that is currently active.
    #
    # The Links renderer cannot be used to render nested navigations. If you
    # would like it to use with nested navigations, you have to render each
    # level separately.
    #
    # By default, the renderer sets the item's key as dom_id for the rendered
    # <a> element unless the config option <tt>autogenerate_item_ids</tt> is set
    # to false.
    # The id can also be explicitely specified by setting the id in the
    # html-options of the 'item' method in the config/navigation.rb file.
    # The ItemContainer's dom_attributes are applied to the surrounding <div>
    # element.
    class Links < RocketNavigation::Renderer::Base
      def render(item_container)
        div_content = ActiveSupport::SafeBuffer.new
        item_container.items.each_with_index do |item, index|
          div_content << tag_for(item)
          unless index == item_container.items.length - 1
            div_content << join_with
          end
        end
        content_tag :div, div_content, container_html
      end

      def join_with
        @join_with ||= options[:join_with] || ''.html_safe
      end

      def options_for(item)
        { method: item.method }.merge(item.html_options)
      end
    end
  end
end
