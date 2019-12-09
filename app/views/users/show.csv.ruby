require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(日付 開始時間 終了時間)
  csv << csv_column_names
  @dates.each do |date|
    column_values = [
      date.worked_on.to_s(:date),
      if date.started_at_2.present? && date.attendance_mark == 3
          date.started_at_2.strftime("%R")
      end,
      if date.finished_at_2.present? && date.attendance_mark == 3
          date.finished_at_2.strftime("%R")
      end
    ]
    csv << column_values
  end
end