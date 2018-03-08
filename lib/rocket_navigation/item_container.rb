module RocketNavigation
  class ItemContainer
    attr_accessor :renderer, :view_context, :options
    attr_reader :items, :level

    attr_accessor :container_html, :item_html, :link_html, :selected_class

    def default_html_options
      if options[:no_default_classes]
        @container_html = {}
        @item_html = {}
        @link_html = {}
        @selected_class = {}
      else
        @container_html = {class: "nav"}
        @item_html = {class: 'nav-item'}
        @link_html = {class: 'nav-link'}
        @selected_class = {branch: "active-branch", item: "active", link: "active"}
      end
    end

    def initialize(level = 1, options = {})
      @level = level
      @items ||= []
      @options = options
      @renderer = RocketNavigation.config.renderer
      default_html_options
    end

    def new_child
      child = ItemContainer.new(level + 1, options)
      child.view_context = view_context
      child
    end

    def item(key, name, url = nil, options = {}, &block)
      return unless should_add_item?(options)
      key = url if key.nil?
      item = Item.new(self, key, name, url, options, &block)
      add_item item, options
    end

    def items=(new_items)
      new_items.each do |item|
        item_adapter = ItemAdapter.new(item)
        next unless should_add_item?(item_adapter.options)
        add_item item_adapter.to_simple_navigation_item(self), item_adapter.options
      end
    end

    # Returns the Item with the specified key, nil otherwise.
    #
    def [](navi_key)
      items.find { |item| item.key == navi_key }
    end

    # Returns the level of the item specified by navi_key.
    # Recursively works its way down the item's sub_navigations if the desired
    # item is not found directly in this container's items.
    # Returns nil if item cannot be found.
    #
    def level_for_item(navi_key)
      return level if self[navi_key]

      items.each do |item|
        next unless item.sub_navigation
        level = item.sub_navigation.level_for_item(navi_key)
        return level if level
      end
      return nil
    end

    # Renders the items in this ItemContainer using the configured renderer.
    #
    # The options are the same as in the view's render_navigation call
    # (they get passed on)
    def render(options = {})
      renderer_instance(options).render(self)
    end

    # Returns true if any of this container's items is selected.
    #
    def selected?
      items.any?(&:selected?)
    end

    # Returns the currently selected item, nil if no item is selected.
    #
    def selected_item
      items.find(&:selected?)
    end

    # Returns true if there are no items defined for this container.
    def empty?
      items.empty?
    end

    def inspect
"#<RocketNavigation::ItemContainer:#{object_id}
  @renderer=#{@renderer.inspect}
  @options=#{@options.inspect}
  @items=#{@items.inspect}
  @level=#{@level.inspect}
  @container_html=#{@container_html.inspect}
  @item_html=#{@item_html.inspect}
  @link_html=#{@link_html.inspect}
  @selected_class=#{@selected_class.inspect}
  @view_context=#{view_context.nil? ? nil : "[rails view context, hidden from inspect]"}
>"
    end

    private

    def add_item(item, options)
      items << item
    end

    def should_add_item?(options)
      [options[:if]].flatten.compact.all? { |m| evaluate_method(m) } &&
      [options[:unless]].flatten.compact.none? { |m| evaluate_method(m) }
    end

    def renderer_instance(options)
      return renderer.new(self, options) unless options[:renderer]

      if options[:renderer].is_a?(Symbol)
        registered_renderer = RocketNavigation.registered_renderers[options[:renderer]]
        registered_renderer.new(self, options)
      else
        options[:renderer].new(self, options)
      end
    end
  end
end

