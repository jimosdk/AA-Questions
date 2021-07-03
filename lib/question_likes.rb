require_relative 'questionsdb.rb'
require_relative 'questions'
require_relative 'users'

class QuestionLike
    attr_accessor :question_id,:user_id

    def self.likers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL,question_id)
            SELECT id,fname,lname
            FROM
                users
                INNER JOIN
                question_likes
                ON
                user_id = id
            WHERE
                question_id = ?
        SQL
        return nil if data.empty?
        data.map{|datum| User.new(datum)}
    end

    def self.num_likes_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL,question_id)
            SELECT COUNT(*) AS number_of_likes
            FROM
                question_likes
            WHERE
                question_id = ?
            GROUP BY question_id
        SQL
        return 0 if data.empty?
        data.first['number_of_likes']

    end

    def self.liked_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL,user_id)
            SELECT 
                id,title,body,author_id
            FROM
                question_likes
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

    def self.most_liked_questions(n)
        data = QuestionsDatabase.instance.execute(<<-SQL,n)
            SELECT 
                id,title,body,author_id
            FROM
                questions
                LEFT JOIN
                question_likes
                ON
                id = question_id
            GROUP BY question_id
            ORDER BY COUNT(user_id) DESC
            LIMIT ?
        SQL
        return nil if data.empty?
        data.map{|datum| Question.new(datum)}
    end

    def initialize(options)
        @question_id = options['question_id']
        @user_id = options['user_id']
    end
end