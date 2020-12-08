class BackupsController < ApplicationController
  def index
    @backups = Backup.all
  end

  def download
    backup = Backup.find(params[:id])
    if backup.present?
      send_data backup.file_content, filename: backup.file_name_with_extension
    else
      redirect_to backups_path, alert: "Backup wurde nicht gefunden"
    end
  end
end
