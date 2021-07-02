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
        return nil if data.empty?
        Question.new(data.first)
    end

    def self.find_by_author_id(author_id)
        data = QuestionsDatabase.instance.execute(<<-SQL,author_id)
            SELECT *
            FROM
                questions
            WHERE
                author_id = ?
        SQL
        return nil if data.empty?
        data.map{|datum| Question.new(datum)}
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def author
        User.find_by_id(author_id)
    end

    def replies
        Reply.find_by_subject_id(id)
    end
end