require './sql_command_generator'
require 'rspec'

describe SqlCommandGenerator do

		before(:each) do
				@command_generator = SqlCommandGenerator.new
		end

		describe "SELECT query" do

				it "should create select query for wanted columns" do
						select_query = @command_generator.select_all("table", ["col1", "col2"])
						select_query.should == "select col1,col2 from table"
				end

				it "should create select query for wanted columns with conditions" do
						where = Where.new(["col1"], ["val1"])
						select_query = @command_generator.select("table", ["col1", "col2"], where)
						select_query.should == "select col1,col2 from table where col1=val1"
				end

		end

		describe "DELETE query" do

				it "should delete from table with no condition" do
						delete_query = @command_generator.delete_all("table")
						delete_query.should == "delete from table"
				end

				it "should create delete query for specified single column value" do
						where = Where.new(["col1"], ["val1"])
						delete_query = @command_generator.delete("table", where)
						delete_query.should == "delete from table where col1=val1"
				end

				it "should create delete query for specified multiple columns values" do
						where = Where.new(["col1", "col2"], ["val1", "val2"])
						delete_query = @command_generator.delete("table", where)
						delete_query.should == "delete from table where col1=val1 and col2=val2"
				end

		end

		describe "UPDATE query" do

				it "should create update query with no condition" do
						update_query = @command_generator.update_all("table", ["col1", "col2"], ["val1", "val2"])
						update_query.should == "update table set col1=val1 and col2=val2"
				end

				it "should create update query with conditions" do
						where = Where.new(["col2"], ["val2"])
						update_query = @command_generator.update("table", ["col1"], ["val1"], where) 
						update_query.should == "update table set col1=val1 where col2=val2"
				end

		end

		describe "INSERT query" do

				it "should create insert query with given columns and vlaues" do
						insert_query = @command_generator.insert("table", ["col1", "col2"], ["val1", "val2"])
						insert_query.should == "insert into table ('col1','col2') values ('val1','val2')"
				end

		end

end
