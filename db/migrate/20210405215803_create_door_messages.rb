class CreateDoorMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :door_messages do |t|
      t.string :message

      t.timestamps
    end
  end
end
