#This class creates a default review for when there is no review available in the app's database.
class DummyReview
	def title
		"No Reviews Yet"
	end
	def revdate
		"N/A"
	end
	def description
		"Reviews Coming Soon!"
	end
end