class AddIndexToPointsName < ActiveRecord::Migration[5.1]
  def change
    add_index :points, :name, unique: true
    add_index :points, :number, unique: true
  end
end
