class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.string :name
      t.integer :number
      t.string :kind

      t.timestamps
    end
  end
end
