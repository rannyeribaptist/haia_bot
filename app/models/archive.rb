class Archive < ApplicationRecord
  mount_uploader :archive, ArchiveUploader
end
