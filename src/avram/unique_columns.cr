module Avram::UniqueColumns
  macro unique_columns(*attribute_names)
    def self.find_or_create!(*args, **named_args)
      operation = new(*args, **named_args)

      existing_record = T::BaseQuery.new
        {% for attribute in attribute_names %}
          .{{ attribute.id }}.nilable_eq(operation.{{ attribute.id }}.value)
        {% end %}
        .first?

      if existing_record
        existing_record
      else
        operation.create!
      end
    end
  end

  # :nodoc:
  def self.find_or_create!(*args, **named_args)
    {% raise "Please call 'unique_columns' on your operation before using 'find_or_create'." %}
  end
end
