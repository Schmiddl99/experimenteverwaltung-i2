class Document < ApplicationRecord
  belongs_to :experiment
  has_attached_file :file,
    path: ":rails_root/public/uploads/documents/:style/:id.:extension",
    url: "/uploads/documents/:style/:id.:extension"
  do_not_validate_attachment_file_type :file
end
