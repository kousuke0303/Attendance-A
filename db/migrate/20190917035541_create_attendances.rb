class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.datetime :plans_end_work_time
      t.string :note
      t.string :overtime_content
      t.integer :overtime_target_user_id
      t.string :overtime_status
      t.integer :overtime_tomorrow_check
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
