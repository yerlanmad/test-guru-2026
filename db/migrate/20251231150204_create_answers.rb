class CreateAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true, index: true
      t.text :body, null: false
      t.boolean :is_correct, null: false, default: false
      t.integer :position, null: false, default: 1

      t.timestamps
    end

    add_index :answers, [:question_id, :is_correct]
  end
end
