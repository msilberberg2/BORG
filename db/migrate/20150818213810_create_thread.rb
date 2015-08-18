class CreateThread < ActiveRecord::Migration
  	def change
		create_table :threads do |t|
	      	t.string :title
	      	t.integer :user_id
	      	t.integer :post_count
	      	t.timestamps
  		end  
  	end
end
