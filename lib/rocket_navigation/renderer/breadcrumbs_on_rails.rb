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
    class BreadcrumbsOnRails < RocketNavigation::Renderer::Base
      def render(item_container)
        item_container.items.each do |item|
          next unless item.selected?
          puts "breadcrumb"
          p item
          add_breadcrumb(item.name, item.url, item_html(item))
          if include_sub_navigation?(item)
            render(item.sub_navigation)
          end
        end
      end
    end
  end
end
