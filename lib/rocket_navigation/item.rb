module RocketNavigation
  # Represents an item in your navigation.
  class Item
    extend Forwardable

    attr_reader :key,
                :name,
                :sub_navigation,
                :url,
                :options

    def_delegators :container, :view_context
    def_delegators :view_context, :is_active_nav_link?

    # see ItemContainer#item
    #
    # The subnavigation (if any) is either provided by a block or
    # passed in directly as <tt>items</tt>
    def initialize(container, key, name, url = nil, opts = {}, &sub_nav_block)
      self.container = container
      self.key = key
      self.name = name.respond_to?(:call) ? name.call : name
      self.url =  url.respond_to?(:call) ? url.call : url
      self.options = opts

      setup_sub_navigation(options[:items], &sub_nav_block)
    end

    # Returns the item's name.
    # If :apply_generator option is set to true (default),
    # the name will be passed to the name_generator specified
    # in the configuration.
    #
    def name(options = {})
      @name
    end

    # Returns true if this navigation item should be rendered as 'selected'.
    # An item is selected if
    #
    # * it has a subnavigation and one of its subnavigation items is selected or
    # * its url matches the url of the current request (auto highlighting)
    #
    def selected?
      @selected ||= selected_by_subnav? || selected_by_condition?
    end

    def active_branch?
      @active_branch ||= selected_by_subnav? && !selected_by_condition?
    end

    def active_leaf?
      @active_leaf ||= selected_by_condition? && !selected_by_subnav?
    end

    # Returns the :highlights_on option as set at initialization
    def highlights_on
      @highlights_on ||= options[:highlights_on]
    end

    # Returns the :method option as set at initialization
    def method
      @method ||= options[:method]
    end

    # Returns true if item has a subnavigation and
    # the sub_navigation is selected
    def selected_by_subnav?
      sub_navigation && sub_navigation.selected?
    end

    # Returns true if the item's url matches the request's current url.
    def selected_by_condition?
      is_active_nav_link?(url, highlights_on)
    end

    # Returns true if both the item's url and the request's url are root_path
    def root_path_match?
      url == '/'
    end

    def inspect
"#<RocketNavigation::Item:#{object_id}
  @key=#{@key}
  @name=#{@name}
  @sub_navigation=#{@sub_navigation.inspect}
  @url=#{@url.inspect}
  @options=#{@options.inspect}
>"
    end

    private

    attr_accessor :container,
                  :options

    attr_writer :key,
                :name,
                :sub_navigation,
                :url


    def remove_anchors(url_with_anchors)
      url_with_anchors && url_with_anchors.split('#').first
    end

    def remove_query_params(url_with_params)
      url_with_params && url_with_params.split('?').first
    end

    def setup_sub_navigation(items = nil, &sub_nav_block)
      return unless sub_nav_block || items

      self.sub_navigation = container.new_child

      if sub_nav_block
        sub_nav_block.call sub_navigation
      else
        sub_navigation.items = items
      end
    end
  end
end

