require 'google_drive'
require 'logger'
require 'csv'

class GoogleDriveService

  # Build the session using the config file
  def self.get_session
    @logger = Logger.new(STDOUT)
    GoogleDrive::Session.from_service_account_key("./config/google_drive_service_api_key.json")
  end  

  def self.call(file)  
    folder_url = "https://drive.google.com/drive/folders/1XNt6xlXnrMUle1j9-cf0VJfltyyTkHuH"
    
    upload_file(file, folder_url)
  end

  def self.upload_file(file, folder_url)
    begin
      session = get_session
      file_path = file.tempfile.path
      file_name = file.original_filename
  
      file_on_drive = session.upload_from_file(file_path, file_name, content_type: file.content_type)
  
      folder = session.folder_by_url(folder_url)
      folder.add(file_on_drive)

      @logger.info "File uploaded successfully: #{file_name}"
    rescue Exception => e
      @logger.warn "Can't upload file: #{file_name}, #{e.message}"
    end
  end
end
