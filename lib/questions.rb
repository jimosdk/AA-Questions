require_relative 'questionsdb.rb'
require_relative 'modelbase'
require_relative 'question_likes'
require_relative 'question_follows'
require_relative 'users'
require_relative 'replies'

class Question < ModelB
    attr_accessor :id ,:title,:body,:author_id

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

    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)
    end

    def self.most_liked(n)
        QuestionLike.most_liked_questions(n)
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

    def followers 
        QuestionFollow.followers_for_question_id(id)
    end

    def likers
        QuestionLike.likers_for_question_id(id)
    end

    def num_likes  
        QuestionLike.num_likes_for_question_id(id)
    end
end