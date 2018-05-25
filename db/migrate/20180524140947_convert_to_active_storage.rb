class ConvertToActiveStorage < ActiveRecord::Migration[5.2]
  def up
    models = [Tracer, Report]

    models.each do |model|
      attachments = model.column_names.map do |c|
        if c =~ /(.+)_file_name$/
          $1
        end
      end.compact

      model.find_each.each do |instance|
        attachments.each do |attachment|
          next unless instance.send("#{attachment}_file_name") # no attachment
          fullpath = path_for(instance, attachment)
          next unless File.exists?(fullpath)
          instance.send(attachment).attach(
            io: File.open(fullpath),
            filename: File.basename(fullpath),
            content_type: instance.send("#{attachment}_content_type")
          )
          instance.send(attachment).save!
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def path_for(instance, attachment)
    # e.g "/path/to/mersea/public/system/tracers/photos/cfa/f68/e5-/original/6150317.png"
    File.join(Rails.root, 'public', 'system', instance.class.name.underscore.pluralize,
              attachment.pluralize, instance.id.scan(/.{3}/).first(3).join('/'.freeze),
              'original', instance.send("#{attachment}_file_name"))
  end
end
