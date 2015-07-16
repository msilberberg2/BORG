class CreateEvent < ActiveRecord::Migration
  def up
  	create_table :events do |e|
  		e.string :title
  		e.string :eventdate
  		e.string :time
  		e.string :location
  		e.text :description
      e.integer :year
  		e.timestamps
  	end
  end

  def down
  	drop_table :events
  end
end
