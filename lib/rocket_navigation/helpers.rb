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
      if block_passed?
        yield :container
      end
      container.render(options)
    end
  end
end
