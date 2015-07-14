class CreateReview < ActiveRecord::Migration
  def up
  	create_table :reviews do |review|
  		review.string :title
  		review.string :picture
  		review.string :pubdate
  		review.string :revdate
  		review.string :author
  		review.text :description
  		review.timestamps
  	end
  end

  def down
  	drop_table :reviews
  end
end
