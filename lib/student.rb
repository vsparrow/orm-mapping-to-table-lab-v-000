class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name,:grade
  attr_reader :id
  def initialize(name,grade,id=nil)
    @name=name
    @grade=grade
    @id=id
  end #initialize

  def self.create_table
    # Use a heredoc to set a variable, sql, equal to the necessary SQL statement.
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
      )
      SQL
      DB[:conn].execute(sql)
  end #create_table

  # a method that can drop that table (from create_table)
  def self.drop_table
    # create a variable sql, and set it equal to the SQL statement that drops the students table.
    # Execute that statement against the database using DB[:conn].execute(sql)
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end #drop_table
  #
  # and a method, #save, that can save the data concerning an individual student object to the database.

  def save
     # sql, and set it equal to the SQL statement that will INSERT the correct data into the table.
     sql = "INSERT INTO students (name,grade) VALUES (?,?)"
     DB[:conn].execute(sql,@name,@grade)
     # you do need to grab the ID of the last inserted row, i.e. the row you just inserted into the database,
     #    and assign it to the be the value of the @id attribute of the given instance.
     sql="SELECT id FROM students WHERE name = (?)"
     id = DB[:conn].execute(sql,@name)
     # puts "***********id#{id[0][0]}"
     @id=id[0][0]
  end #save
  #Student.create("Sally","10th")
  def self.create(name:, grade:)
    # puts "************#{name} #{grade}"   #get .************Sally 10th
    s = Student.new(name,grade) #create object
    s.save                      #save object
    s                           #return obj
  end #create
end
