# Fix fancy PaperClip's glue..
GLUE_COLUMNS = {
  file_name: :string,
  content_type: :string,
  file_size: :integer,
  updated_at: :datetime
}

module ActiveRecord
  module ConnectionAdapters
    TableDefinition.class_eval do
      def attachment(*attachment_names)
        # just to handle paperclip stuff for old migrations
        options = attachment_names.extract_options!
        attachment_names.each do |attachment_name|
          GLUE_COLUMNS.each_pair do |column_name, column_type|
            column_options = options.merge(options[column_name.to_sym] || {})
            column("#{attachment_name}_#{column_name}", column_type, column_options)
          end
        end
      end
    end
  end

  Migration.class_eval do
    def add_attachment(tablename, field)
      # just to handle paperclip stuff for old migrations
    end

    def remove_attachment(*_)
      # just to handle paperclip stuff for old migrations
    end
  end
end
