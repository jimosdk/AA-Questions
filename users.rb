require_relative 'questionsdb.rb'
require_relative 'questions'

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
        return nil if data.empty?
        User.new(data.first)
    end

    def self.find_by_name(fname,lname = nil)
        data = QuestionsDatabase.instance.execute(<<-SQL,fname: fname,lname: lname)
            SELECT * 
            FROM
                users
            WHERE
                fname = :fname AND
                (lname = :lname OR
                (:lname IS NULL AND 
                lname IS NULL))
        SQL
        return nil if data.empty?
        User.new(data.first)
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_author_id(id)
    end

    def followed_questions 
        QuestionFollow.followed_questions_for_user_id(id)
    end
end