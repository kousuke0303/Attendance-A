class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :prev_started_at
      t.datetime :first_started_at
      t.datetime :finished_at
      t.datetime :prev_finished_at
      t.datetime :first_finished_at
      t.datetime :plans_end_work_time
      t.string :note
      t.string :overtime
      t.string :overtime_content
      t.integer :overtime_target_user_id
      t.string :overtime_status
      t.integer :overtime_tomorrow_check
      t.integer :overnight
      t.integer :edit_target_user_id
      t.string :edit_status
      t.integer :approve_check
      t.date :approved_edit
      t.integer :year
      t.integer :month
      t.references :user, foreign_key: true
      t.integer :month_target_user_id
      t.string :month_status

      t.timestamps
    end
  end
end
