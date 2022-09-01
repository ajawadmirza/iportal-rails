require 'base64'
require 'aws-sdk-s3'

class FileUploader
    def self.upload_file(content_type, extension, file)
        bucket = Aws::S3::Resource.new.bucket(ENV['AWS_S3_BUCKET'])
        data = Base64.decode64(file.to_s)
        type = content_type.to_s
        extension = extension.to_s
        name = ('a'..'z').to_a.shuffle[0..7].join + ".#{extension}"
        obj = bucket.put_object(key: name, body: data)
        url = obj.public_url().to_s
        url
    end
end