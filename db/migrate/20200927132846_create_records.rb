class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.reference :user
      t.reference :topic
      t.string :remark

      t.timestamps
    end
  end
end
