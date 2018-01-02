class User < ApplicationRecord
  mount_uploader :picture, PictureUserUploader
end
