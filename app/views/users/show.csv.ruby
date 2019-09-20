require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(name email created_at)
  csv << csv_column_names
  
  column_values = [
    @user.name,
    @user.email,
    @user.created_at
  ]
  csv << column_values
  
end