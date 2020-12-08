require 'csv'
class Import
  def self.run
    no_file = []
    Experiment.delete_all
    Medium.delete_all
    CSV.read("/home/witt/liste.csv").each do |label, name, media|
      e = Experiment.where(label: label.strip).first_or_initialize
      e.name = name.strip
      e.description = "Automatisch importiert"
      e.sub_category = sub_category(label)
      e.user = User.first
      e.save!
      if media.present?
        media.split(";").each_with_index do |media_name, i|
          file = "/home/witt/DB_Bilder/#{media_name}.jpg"
          if File.exist?(file)
            Rails.logger.info "#{file} > #{e.label} #{e.name}"
            media_record = Medium.new
            media_record.experiment = e
            media_record.sort = i
            media_record.file = File.open(file)
            media_record.save!
          else
            no_file << file
          end
        end
      else
        Rails.logger.info "kein Bild"
      end
    end
    no_file.join(",")
  end

  def self.sub_category(label)
    raw_label = label.split(".").first
    SubCategory.find_by(label: raw_label)
  end
end
