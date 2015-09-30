class Post < ActiveRecord::Base
	belongs_to :topic
	belongs_to :user

	#Creates a forum post with the given parameters
	def self.create_post(user_id, topic_id, content)
		self.create(user_id: user_id, topic_id: topic_id, content: content)
		topic = Topic.find(topic_id)
		topic.post_count = topic.post_count + 1
		topic.save
	end
end