class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.string :title
      t.string :description
      t.reference :user

      t.timestamps
    end
  end
end
