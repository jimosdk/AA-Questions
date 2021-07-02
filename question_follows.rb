require_relative 'questions'

class QuestionFollow
    attr_accessor :question_id,:user_id

    def initialize(options)
        @question_id = options['question_id']
        @user_id = options['user_id']
    end
end

