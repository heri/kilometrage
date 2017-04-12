class AddKilometrage < ActiveRecord::Migration
  def change
    add_column :tracks, :mileage, :float, default: 0
  end
end
