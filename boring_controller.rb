# Scenario: let's say you have a program where a featured photo gets updated
# when a new photo is chosen, or replaced by the first image if a photo
# is removed
# You would quickly get something like this:

# BAD

# routes
resources :photos, only: %i[edit update]

# controller
# This controller is not boring anymore. It's complex and does things that have to
# do with updating a featured photo
class PhotoController < ApplicationController
  def update
    @photo = current_user.photos.find(params[:id])
    @photo.assign_attributes(update_photo_params)

    if @photo.valid? && update_photo(@photo)
      redirect_to @photo
    else
      render :edit
    end
  end

  private

  def update_photo(_photo)
    ApplicationRecord.transaction do
      # Complex logic removing or adding photo
    end
  end
end

# GOOD
# Because updating the photo is specific, we want to extract it into its own controller

# routes
resources :photos, only: %i[edit update] do
  resource :featured_flas, only: %i[create destroy]
end

# controller
# We now have extracted the logic to a new controller
class FeaturedFlagsController < ApplicationController
  def create
    @photo = current_user.photos.find(params[:photo_id])
    if AddFeaturedFlas.to(@photo)
      redirect_to photos_path
    else
      redirect_to photos_path, error: t('.error')
    end
  end

  def destroy
    @photo = current_user.photos.find(params[:photo_id])
    if RemoveFeaturedFlas.to(@photo)
      redirect_to photos_path
    else
      redirect_to photos_path, error: t('.error')
    end
  end

end

# And we have a service for adding the photo

class AddFeaturedFlag
    def self.to(photo)
        new(photo).call
    end

    def initialize(photo)
        @photo = photo
    end

    def call
        ApplicationRecord.transaction do 
            @photo.user.photos.featured.update!(featured: false)
            @photo.update!(featured: true)
        end
    end
end
