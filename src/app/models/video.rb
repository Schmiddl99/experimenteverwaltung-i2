class Video < ApplicationRecord
  belongs_to :experiment
  has_attached_file :file,
    path: ":rails_root/public/uploads/videos/:style/:id.:extension",
    url: "/uploads/videos/:style/:id.:extension"
  do_not_validate_attachment_file_type :file
end
