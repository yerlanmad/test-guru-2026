class CreateTestResults < ActiveRecord::Migration[8.1]
  def change
    create_table :test_results do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :test, null: false, foreign_key: true, index: true
      t.decimal :score, precision: 5, scale: 2, null: false, default: 0.0
      t.integer :correct_answers, null: false, default: 0
      t.integer :total_questions, null: false
      t.string :status, null: false, default: 'in_progress'
      t.datetime :started_at, null: false
      t.datetime :completed_at
      t.integer :time_spent

      t.timestamps
    end

    add_index :test_results, [:user_id, :test_id]
    add_index :test_results, :status
    add_index :test_results, :score
    add_index :test_results, :created_at
  end
end
