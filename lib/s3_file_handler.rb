require "base64"
require "aws-sdk-s3"

class FileHandler
  @bucket = Aws::S3::Resource.new.bucket(ENV["AWS_S3_BUCKET"])

  def self.upload_file(content_type, extension, file)
    begin
      data = Base64.decode64(file.to_s)
      type = content_type.to_s
      extension = extension.to_s
      name = ("a".."z").to_a.shuffle[0..7].join + ".#{extension}"
      obj = @bucket.put_object(key: name, body: data)
      url = obj.public_url().to_s
      return { url: url, key: name }
    rescue => e
      return { error: e.message }
    end
  end

  def self.delete_file(key)
    begin
      return @bucket.delete_objects({
               delete: {
                 objects: [
                   { key: key },
                 ],
               },
             })
    rescue => e
      return { error: e.message }
    end
  end

  def self.update_file_with_new_key(key, content_type, extension, file)
    begin
      self.delete_file(key)
      return self.upload_file(content_type, extension, file)
    rescue => e
      return { error: e.message }
    end
  end
end
