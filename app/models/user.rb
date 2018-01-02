# frozen_string_literal: true

class User < ApplicationRecord
  mount_uploader :picture, PictureUserUploader
end
