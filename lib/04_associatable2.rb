require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)

    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      source = source_options.table_name
      through = through_options.table_name
      through_id = send("#{through_name}").id
      result = DBConnection.execute(<<-SQL, through_id)
        SELECT
          #{source}.*
        FROM
          #{through}
        JOIN
          #{source} ON #{through}.#{source_options.foreign_key} = #{source}.#{source_options.primary_key.to_s}
        WHERE
          #{through}.#{through_options.primary_key.to_s} = ?
      SQL
      source_options.model_class.new(result.first)
    end
  end
end
