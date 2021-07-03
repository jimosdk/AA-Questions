require 'active_support/inflector'
require_relative 'questionsdb'
require_relative 'questions'
require_relative 'users'
require 'byebug'
class ModelB

    def self.find_by_id(id)
        t = self.to_s.underscore.tableize
        data = QuestionsDatabase.instance.execute(<<-SQL,id)
            SELECT *
            FROM
                #{t}
            WHERE
                id = ?
        SQL
        return nil if data.empty?
        self.new(data.first)
    end

    def self.all
        t = self.to_s.underscore.tableize
        data = QuestionsDatabase.instance.execute("SELECT * FROM #{t}")
        return nil if data.empty?
        data.map{|datum| self.new(datum)}
    end

    def save
        #debugger
        t = self.class.to_s.underscore.tableize
        v = self.instance_variables
        v.delete(:@id)
        v.map!{|col| col.to_s[1..-1].to_sym}
        if id.nil?

            col = v.join(',')
            interp = v.map{|el| '?'}.join(',')
            v.map!{|var| self.__send__(var)}

            QuestionsDatabase.instance.execute(<<-SQL,*v)
                INSERT INTO
                    #{t}(#{col})
                VALUES
                    (#{interp})
            SQL
            @id = QuestionsDatabase.instance.last_insert_row_id
        else  
            interp = v.map{|el| "#{el} = ?"}.join(',')
            v.map!{|var| self.__send__(var)}
            QuestionsDatabase.instance.execute(<<-SQL,*v,id)
            UPDATE
                #{t}
            SET
                #{interp}
            WHERE 
                id = ?
            SQL
        end
    end

    

end