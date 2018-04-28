module Concerns
  module Filterable
    extend ActiveSupport::Concern

    module ClassMethods
      def filter(filtering_params)
        results = self.where(nil)
        filtering_params.each do |key, value|
          next if value.blank?
          if relationship?(key)
            foreign_key = self.name.foreign_key
            inner_table = relationship_name(key).tableize
            query = "id IN (SELECT DISTINCT #{foreign_key} FROM #{inner_table} " \
              "WHERE #{inner_table}.id = ?)"
            case value
            when String
              results = results.where(query, value)
            when Array
              value.each do |v|
                results = results.where(query, v)
              end
            end
          else
            # Basic model attribute
            results = results.where("#{key}": value)
          end
        end
        results
      end

      private

      def relationship?(name)
        rs = name.to_s
        !self.has_attribute?(name) &&
          rs.end_with?('_id', '_ids') &&
          _self.respond_to?(relationship_name(rs))
      end

      def relationship_name(name)
        name.to_s.sub('_id', '')
      end

      def _self
        @_self ||= self.new
      end
    end
  end
end
