namespace :storage do
  desc 'Diet all images'
  task diet: :environment do
    ActiveStorage::Attachment.find_each.each do |attachment|
      next if attachment.name != "photo"
      puts "Attachement #{attachment.id}"

      path = ActiveStorage::Blob.service.send(:path_for, attachment.key)
      puts "     path: #{path}"
      puts "     size: #{File.size(path)}"

      ImageProcessing::MiniMagick
        .source(path)
        .resize_to_limit(1920, 1080)
        .quality(90)
        .convert("jpg")
        .call(save: true, destination: path)

      puts "  newsize: #{File.size(path)}"
    end
  end
end
