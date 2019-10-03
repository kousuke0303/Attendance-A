require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(worked_on started_at finished_at)
  csv << csv_column_names
  @attendances.each do |day|
    column_values = [
      day.worked_on,
      day.started_at,
      day.finished_at
    ]
    csv << column_values
  end
end