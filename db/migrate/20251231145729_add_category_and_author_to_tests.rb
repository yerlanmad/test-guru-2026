class AddCategoryAndAuthorToTests < ActiveRecord::Migration[8.1]
  def change
    add_reference :tests, :category, foreign_key: true, index: true
    add_reference :tests, :author, foreign_key: { to_table: :users }, index: true

    reversible do |dir|
      dir.up do
        default_category = Category.find_or_create_by!(title: 'Без категории') do |c|
          c.description = 'Категория по умолчанию'
        end

        system_user = User.find_or_create_by!(email: 'system@testguru.local') do |u|
          u.password = SecureRandom.hex(32)
          u.role = 'admin'
          u.confirmed_at = Time.current
        end

        Test.where(category_id: nil).update_all(category_id: default_category.id)
        Test.where(author_id: nil).update_all(author_id: system_user.id)
      end
    end

    change_column_null :tests, :category_id, false
    change_column_null :tests, :author_id, false
  end
end
