require_relative 'questions'

class QuestionFollow
    attr_accessor :question_id,:user_id

    def self.followers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL,question_id)
            SELECT 
                id,fname,lname
            FROM
                question_follows 
                INNER JOIN
                users
                ON
                user_id = id
            WHERE
                question_id = ?
        SQL
        return nil if data.empty?
        data.map{|datum| User.new(datum)}
    end

    def self.followed_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL,user_id)
            SELECT 
                id,title,body,author_id
            FROM
                question_follows
                INNER JOIN
                questions
                ON
                id = question_id
            WHERE
                user_id = ?
        SQL
        return nil if data.empty?
        data.map{|datum| Question.new(datum)}
    end

    def initialize(options)
        @question_id = options['question_id']
        @user_id = options['user_id']
    end
end

