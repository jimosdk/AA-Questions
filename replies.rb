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
        Reply.new(data.first)
    end

    def initialize(options)
        @id = options['id']
        @body = options['body']
        @author_id = options['author_id']
        @subject_id = options['subject_id']
        @parent_id = options['parent_id']
    end
end