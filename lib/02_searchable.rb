require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = []
    params.each do |attr_name, value|
      where_line << "#{attr_name} = ?"
    end
    where_line = where_line.join(' AND ')
    results = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL
    results.map do |result|
      self.new(result)
    end
  end
end

class SQLObject
  extend Searchable
end
