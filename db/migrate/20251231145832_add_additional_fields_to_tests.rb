class AddAdditionalFieldsToTests < ActiveRecord::Migration[8.1]
  def change
    add_column :tests, :description, :text
    add_column :tests, :time_limit, :integer
    add_column :tests, :passing_score, :integer, null: false, default: 70
    add_column :tests, :published, :boolean, null: false, default: false

    change_column_default :tests, :level, from: nil, to: 1
    change_column_null :tests, :level, false

    add_index :tests, :level
    add_index :tests, :published
    add_index :tests, [:title, :category_id], unique: true
  end
end
