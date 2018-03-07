module Helpers
  def select_an_item(item)
    allow(item).to receive_messages(selected?: true)
  end

  def setup_navigation(dom_id, dom_class)
    container = setup_container(dom_id, dom_class)
    setup_items(container)
    container
  end

  def setup_container(dom_id, dom_class)
    container = RocketNavigation::ItemContainer.new(1)
    container.dom_attributes = {id: dom_id, class: dom_class}
    container
  end

  # FIXME: adding the :link option for the list renderer messes up the other
  #        renderers
  def setup_items(container)
    container.item :users, 'Users', '/users', html: { id: 'users_id' }, link_html: { id: 'users_link_id' }
    container.item :invoices, 'Invoices', '/invoices' do |invoices|
      invoices.item :paid, 'Paid', '/invoices/paid'
      invoices.item :unpaid, 'Unpaid', '/invoices/unpaid'
    end
    container.item :accounts, 'Accounts', '/accounts', html: { style: 'float:right' }
    container.item :miscellany, 'Miscellany'

    container.items.each do |item|
      allow(item).to receive_messages(selected?: false, selected_by_condition?: false)

      if item.sub_navigation
        item.sub_navigation.items.each do |item|
            allow(item).to receive_messages(selected?: false, selected_by_condition?: false)
        end
      end
    end
  end
end
