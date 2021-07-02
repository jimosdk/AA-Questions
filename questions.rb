require_relative 'users'


class Question  
    attr_accessor :id ,:title,:body,:author_id

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL,id)
            SELECT *
            FROM 
                questions
            WHERE
                id = ?
        SQL
        Question.new(data.first)
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

end