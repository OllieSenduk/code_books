# Transactions are protective blocks where
# SQL statements are only permanent if they can all succeed as one atomic action.

# you should use transaction blocks whenever
# you have a number of statements that must be executed together or not at all.

ActiveRecord::Base.transaction do
  david.withdrawal(100)
  mary.deposit(100)
end

class Post < ApplicationRecord
  def duplicate!
    ActiveRecord::Base.transaction do
      post_dup = dup
      post_dup.save!
      comments.find_each do |comment|
        comment_dup = comment.dup
        comment_dup.post_id = post_dup.id
        comment_dup.save!
      end
    end
  end
end
