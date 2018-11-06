class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :request_number
      t.bigint :sequence_number, uniq: true
      t.string :request_type
      t.datetime :response_due
      t.string :primary_sacode
      t.string :additional_sacodes, array: true
      t.text :well_known_text
    end
  end
end
