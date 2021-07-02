require_relative 'questionsdb.rb'

class User
    attr_accessor :id,:fname,:lanme

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL,id)
            SELECT *
            FROM
                users
            WHERE
                id = ?
        SQL
        User.new(data.first)
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

end