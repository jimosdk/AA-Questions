require_relative 'questions'

class Reply
    attr_accessor :id,:body,:author_id,:subject_id,:parent_id

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL,id)
            SELECT *
            FROM
                replies
            WHERE
                id = ?
        SQL
        return nil if data.empty?
        Reply.new(data.first)
    end

    def self.find_by_author_id(author_id)
        data = QuestionsDatabase.instance.execute(<<-SQL,author_id)
            SELECT *
            FROM
                replies
            WHERE
                author_id = ?
        SQL
        return nil if data.empty?
        data.map{|datum| Reply.new(datum)}
    end

    def self.find_by_subject_id(subject_id)
        data = QuestionsDatabase.instance.execute(<<-SQL,subject_id)
            SELECT *
            FROM
                replies
            WHERE
                subject_id = ?
        SQL
        return nil if data.empty?
        data.map{|datum| Reply.new(datum)}
    end

    def initialize(options)
        @id = options['id']
        @body = options['body']
        @author_id = options['author_id']
        @subject_id = options['subject_id']
        @parent_id = options['parent_id']
    end

    def author
        User.find_by_id(author_id)
    end

    def question
        Question.find_by_id(subject_id)
    end

    def parent_reply
        Reply.find_by_id(parent_id)
    end

    def child_replies
        data = QuestionsDatabase.instance.execute(<<-SQL,id: id)
            SELECT *
            FROM
                replies
            WHERE
                parent_id = :id
        SQL
        return nil if data.empty?
        data.map{|datum| Reply.new(datum)}
    end
end