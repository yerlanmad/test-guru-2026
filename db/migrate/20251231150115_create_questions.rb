class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.references :test, null: false, foreign_key: true, index: true
      t.text :body, null: false
      t.integer :position, null: false, default: 1
      t.string :question_type, null: false, default: 'single_choice'
      t.integer :points, null: false, default: 1

      t.timestamps
    end

    add_index :questions, [:test_id, :position]
  end
end
