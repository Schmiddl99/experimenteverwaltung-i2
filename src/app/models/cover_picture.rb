class CoverPicture < ApplicationRecord
  # validates :current, presence: true

  has_attached_file :file,
    styles: { medium: ["300x300^", "png"], thumb: ["100x100^", "png"] },
    path: ":rails_root/public/uploads/CoverPicture/:style/:id.:extension",
    url: "/uploads/CoverPicture/:style/:id.:extension"
  validates_attachment :file, content_type: { content_type: ["image/png", "image/jpg", "image/jpeg"] }
end
