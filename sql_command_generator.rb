class SqlCommandGenerator

		SELECT = "select "
		DELETE = "delete from "
		UPDATE = "update "
		INSERT = "insert into "
		SET = " set "


		def select_all table_name, columns
				SELECT + columns.join(",") + " from " + table_name
		end

		def select(table, selecting_columns, where) 
				select_all(table, selecting_columns) + where.to_s
		end

		def delete_all table
				DELETE + table
		end

		def delete table, where 
				delete_all(table) + where.to_s 
		end

		def update_all table, columns, values
				UPDATE + table + SET + StringQueryShaper.columns_equal_values(columns, values)
		end

		def update table, columns, values, where 
				update_all(table, columns, values) + where.to_s
		end

		def insert table, columns, values
				INSERT + table + StringQueryShaper.columns_values_pair_for_insert(columns, values)
		end

end


class Where

		WHERE = " where "

		def initialize columns, values
				@columns = columns
				@values = values
		end

		def to_s
				WHERE + StringQueryShaper.columns_equal_values(@columns, @values)
		end

end

class StringQueryShaper

		AND = " and "
		VALUES = " values "
		EMPTY_SPACE = " "
		EQUAL = "="

		def self.columns_equal_values columns, values
				columns_equal_values = ""
				columns.each_with_index do |col, index|
						columns_equal_values += columns[index] + EQUAL + values[index]
						columns_equal_values += AND unless index == columns.length - 1
				end

				columns_equal_values
		end

		def self.columns_values_pair_for_insert(columns, values)
				shaped_columns = shape columns
				shaped_values = shape values
				EMPTY_SPACE + shaped_columns + VALUES + shaped_values
		end

		private
		def self.shape texts
				single_quoted = texts.map { |text| "'" + text + "'" }
				joined = single_quoted.join(",")
				"(" + joined + ")"
		end

end
