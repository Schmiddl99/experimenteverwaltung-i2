class Medium < ApplicationRecord
  belongs_to :experiment, required: false
  # validates :name, presence: true
  # validates :sorting_nr, presence: true
  # validates :type, presence: true
  enum media_type: [:bild, :video]
  has_attached_file :file,
    styles: { medium: ["300x300^", "png"], thumb: ["100x100^", "png"] },
    path: ":rails_root/public/uploads/media/:style/:id.:extension",
    url: "/uploads/media/:style/:id.:extension"
  validates_attachment :file, content_type: { content_type: ["image/png", "image/jpg", "image/jpeg"] }

  def file_name
    file.original_filename.split(/(.pdf|.png|.jpg)/)[0]
  end
end
