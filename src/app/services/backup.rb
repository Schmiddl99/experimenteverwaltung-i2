class Backup
  PATH = Rails.root.join('backups').freeze
  class << self
    def all
      files = Dir.entries(PATH).map do |f|
        next if f.start_with?(".")
        Backup.new(f)
      end
      files.compact.sort { |a, b| b.created_at <=> a.created_at }
    end

    def find(name)
      file = Backup.new("#{name}.zip")
      file if file.exist?
    end
  end

  def initialize(name)
    @name = name
  end

  def created_at
    File.ctime(path)
  end

  def exist?
    File.file?(path)
  end

  def file_name_with_extension
    @name
  end

  def file_name
    @name.gsub(".zip", "")
  end

  def file_content
    File.read(path)
  end

  def file_size
    File.size(path)
  end

  private

  def path
    "#{PATH}/#{@name}"
  end
end
