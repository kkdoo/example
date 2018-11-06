class CreateExcavators < ActiveRecord::Migration[5.2]
  def change
    create_table :excavators do |t|
      t.belongs_to :ticket
      t.string :company_name
      t.string :address
      t.boolean :crew_onsite
    end
  end
end
