require_relative 'questionsdb.rb'
require_relative 'modelbase'
require_relative 'question_likes'
require_relative 'question_follows'
require_relative 'questions'
require_relative 'replies'


class User < ModelB
    attr_accessor :id,:fname,:lname

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

    def liked_questions  
        QuestionLike.liked_questions_for_user_id(id)
    end

    def average_karma
        data = QuestionsDatabase.instance.execute(<<-SQL,id: id)
            SELECT
                AVG(number_of_likes) AS average_karma
            FROM
                (
                    SELECT 
                        author_id,COUNT(user_id) AS number_of_likes
                    FROM
                        questions
                        LEFT JOIN
                        question_likes
                        ON
                        id = question_id
                    WHERE
                        author_id = :id
                    GROUP BY id
                ) AS likes_per_question 
            GROUP BY author_id
        SQL
        return nil if data.empty?
        data.first['average_karma']
    end
end