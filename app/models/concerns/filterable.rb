module Concerns
  module Filterable
    extend ActiveSupport::Concern

    module ClassMethods
      def filter(filtering_params)
        results = self.where(nil)
        filtering_params.each do |key, value|
          next if value.blank?

          case
          when range?(key)
            # e.g. `?r_min_created_at=2019-02-12&r_max_created_at=2019-02-12`
            results = range(results, key, value)
          when relationship?(key)
            # When the field is not directly defined on the model
            results = relationship(results, key, value)
          else
            # Basic model attribute
            results = results.where("#{key}": value)
          end
        end
        results
      end

      private

      def range?(name)
        rs = name.to_s
        !self.has_attribute?(name) && # is not a field of current model
          rs.start_with?('r_min_', 'r_max_') && # is a range prefix
          self.has_attribute?(rs.gsub(/r_min_|r_max_/, '')) # is a prefixed field
      end

      def range(results, key, value)
        _, operator, field = key.partition(/r_min_|r_max_/)

        case operator
        when "r_min_"
          results = results.where("#{field} >= ?", value)
        when "r_max_"
          results = results.where("#{field} <= ?", value)
        end

        results
      end

      def relationship(results, key, value)
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

        results
      end

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
