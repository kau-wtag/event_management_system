class AddRegistrationDatesToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :registration_start_date, :datetime
    add_column :events, :registration_end_date, :datetime
  end
end
