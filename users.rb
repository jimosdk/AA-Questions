require_relative 'questionsdb.rb'

class User
    attr_accessor :id,:fname,:lanme

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

end