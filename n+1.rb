# We want to avoid doing multiple queries, this example does 11
# The code executes 1 (to find 10 clients)
# + 10 (one per each client to load the address)
# = 11 queries in total.

clients = Client.limit(10)

clients.each do |client|
  puts client.address.postcode
end

# Instead, we can use "includes"

clients = Client.includes(:address).limit(10)

clients.each do |client|
  puts client.address.postcode
end

# For multiple associations

Article.includes(:category, :comments)

# Or for nested association hash
# This will find the category with id 1
# and eager load all of the associated articles,
# the associated articles' tags and comments, and every comment's guest association

Category.includes(articles: [{ comments: :guest }, :tags]).find(1)
