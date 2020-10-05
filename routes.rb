# A route should always constitute just a noun and a verb.

# BAD
resource :user, only: %i[edit update] do
  get :edit_password, on: 'member'
  put :update_password, on: 'member'
end

# written out, you would have:
get 'users/edit_password', to: 'users#edit_password'
# here you have noun/verb_noun

# GOOD
resource :user, only: %i[edit update] do
  resources :password, only: %i[edit update]
end

# This way, passwords get their own controller.
# Controllers do not need to map models!
