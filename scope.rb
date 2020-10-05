# When you want to find a certain set of data, or want data ordered in a certain way
# we want to remove this code from the controller and put it in the model.

class UserController < ApplicationController
  def index
    @users = users.ordered
  end
end

class User < ActiveRecord::Base
  # Prefered way
  scope :ordered, order('last_name')

  # Other way
  def ordered
    order('last_name')
  end
end

# EXAMPLE 2. Association Proxy

# When we want to retreive certain members in our user controller, we can do
# so as follows. The following example is still not ideal because we keep information
# we're doing a query on the membership class inside the User class.

class UserController < ApplicationController
  def show
    @user = User.find(params[:id])
    @active_members = @user.find_active_members
  end
end

class User < ActiveRecord::Base
  has_many :memberships

  def find_active_members
    memberships.where(active: true).limit(5).order('last_active_on DESC')
  end
end

# Instead we can use active records proxy association power, that can user
# utilize a class method and link it to its association when called on it

class UserController < ApplicationController
  def show
    @user = User.find(params[:id])
    @active_members = @user.find_active_members
  end
end

class User < ActiveRecord::Base
  has_many :memberships

  def find_active_members
    memberships.find_recently_active
  end
end

class Membership < ActiveRecord::Base
  belongs_to :user

  def self.find_recently_active
    where(active: true).limit(5).order('last_active_on DESC')
  end
end

# EXAMPLE 3. Linking Scopes. In this example we've extracted our query into
# 3 seperate scopes, that we can then link

class Membership < ActiveRecord::Base
  belongs_to :user

  scope :only_active, where(active: true)
  scope :order_by_activity, order('last_active_on DESC')
  scope :limit_results, limit(5)
end

class User < ActiveRecord::Base
  has_many :memberships

  def find_active_members
    memberships.only_active.order_by_activity.limit_results
  end
end

Article.created_before(Time.zone.now)

class Article < ApplicationRecord
  scope :published,               -> { where(published: true) }
  scope :published_and_commented, -> { published.where('comments_count > 0') }
end

# Other example that takes an argument:

class Article < ApplicationRecord
  scope :created_before, ->(time) { where('created_at < ?', time) }
end

# With conditional

class Article < ApplicationRecord
  scope :created_before, ->(time) { where('created_at < ?', time) if time.present? }
end

# Written differently, this would be:

class Article < ApplicationRecord
  def self.created_before(time)
    where('created_at < ?', time) if time.present?
  end
end
