module RocketNavigation
  # View helpers to render the navigation.
  #
  # Use render_navigation as following to render your navigation:
  # * call <tt>render_navigation</tt> without :level option to render your
  #   complete navigation as nested tree.
  # * call <tt>render_navigation(level: x)</tt> to render a specific
  #   navigation level (e.g. level: 1 to render your primary navigation,
  #   level: 2 to render the sub navigation and so forth)
  # * call <tt>render_navigation(:level => 2..3)</tt> to render navigation
  #   levels 2 and 3).
  #
  # For example, you could use render_navigation(level: 1) to render your
  # primary navigation as tabs and render_navigation(level: 2..3) to render
  # the rest of the navigation as a tree in a sidebar.
  #
  # ==== Examples (using Haml)
  #   #primary_navigation= render_navigation(level: 1)
  #
  #   #sub_navigation= render_navigation(level: 2)
  #
  #   #nested_navigation= render_navigation
  #
  #   #top_navigation= render_navigation(level: 1..2)
  #   #sidebar_navigation= render_navigation(level: 3)
  module Helpers
    # Renders the navigation according to the specified options-hash.
    #
    # The following options are supported:
    # * <tt>:level</tt> - defaults to :all which renders the the sub_navigation
    #   for an active primary_navigation inside that active
    #   primary_navigation item.
    #   Specify a specific level to only render that level of navigation
    #   (e.g. level: 1 for primary_navigation, etc).
    #   Specifiy a Range of levels to render only those specific levels
    #   (e.g. level: 1..2 to render both your first and second levels, maybe
    #   you want to render your third level somewhere else on the page)
    # * <tt>:expand_all</tt> - defaults to false. If set to true the all
    #   specified levels will be rendered as a fully expanded
    #   tree (always open). This is useful for javascript menus like Superfish.
    # * <tt>:items</tt> - you can specify the items directly (e.g. if items are
    #   dynamically generated from database).
    #   See SimpleNavigation::ItemsProvider for documentation on what to
    #   provide as items.
    # * <tt>:renderer</tt> - specify the renderer to be used for rendering the
    #   navigation. Either provide the Class or a symbol matching a registered
    #   renderer. Defaults to :list (html list renderer).
    #
    # Instead of using the <tt>:items</tt> option, a block can be passed to
    # specify the items dynamically
    #
    # ==== Examples
    #   render_navigation do |menu|
    #     menu.item :posts, "Posts", posts_path
    #   end
    #
    def render_navigation(options = {}, &block)
      container = ItemContainer.new(options)
      container.view_context = view_context
      if block_given?
        yield container
      end
      container.render(options)
    end

    # Returns true or false based on the provided path and condition
    # Possible condition values are:
    #                  Boolean -> true | false
    #                   Symbol -> :exclusive | :inclusive
    #                    Regex -> /regex/
    #   Controller/Action Pair -> [[:controller], [:action_a, :action_b]]
    #
    # Example usage:
    #
    #   is_active_nav_link?('/root', true)
    #   is_active_nav_link?('/root', :exclusive)
    #   is_active_nav_link?('/root', /^\/root/)
    #   is_active_nav_link?('/root', ['users', ['show', 'edit']])
    #
    # Source: https://github.com/comfy/active_link_to/blob/master/lib/active_link_to/active_link_to.rb
    # Copyright (c) 2009-17 Oleg Khabarov
    # MIT License
    def is_active_nav_link?(url, condition = nil)
      @is_active_link ||= {}
      @is_active_link[[url, condition]] ||= begin
        original_url = url
        url = Addressable::URI::parse(url).path
        path = request.original_fullpath
        case condition
        when :inclusive, nil
          !path.match(/^#{Regexp.escape(url).chomp('/')}(\/.*|\?.*)?$/).blank?
        when :exclusive
          !path.match(/^#{Regexp.escape(url)}\/?(\?.*)?$/).blank?
        when :exact
          path == original_url
        when Proc
          condition.call(original_url)
        when Regexp
          !path.match(condition).blank?
        when Array
          controllers = [*condition[0]]
          actions     = [*condition[1]]
          (controllers.blank? || controllers.member?(params[:controller])) &&
          (actions.blank? || actions.member?(params[:action])) ||
          controllers.any? do |controller, action|
            params[:controller] == controller.to_s && params[:action] == action.to_s
          end
        when TrueClass
          true
        when FalseClass
          false
        when Hash
          condition.all? do |key, value|
            params[key].to_s == value.to_s
          end
        end
      end
    end
  end
end
