RSpec.feature 'Rendering navigation' do
  background do
  end

  scenario 'Rendering basic navigation', type: :feature do
    visit '/base_spec'

    expect(page).to have_content('Item 1')
    expect(page).to have_content('Item 2')
    expect(page).to have_selector('li.item_1 a#link_1')
    expect(page).to have_selector('li.item_2 a#link_2')
  end
end
