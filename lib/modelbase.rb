require 'active_support/inflector'
require_relative 'questionsdb'

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

    def self.where(options)
        t = self.to_s.underscore.tableize
        if options.is_a?(Hash)
            keys = options.keys
            v = options.values
            interp = keys.map{|key| "#{key} = ?"}.join(' AND ')
            data = QuestionsDatabase.instance.execute(<<-SQL,*v)
                SELECT *
                FROM
                    #{t}
                WHERE
                    #{interp}
            SQL
            return nil if data.empty?
            data.map{|datum| self.new(datum)}
        elsif options.is_a?(String)
            data = QuestionsDatabase.instance.execute(<<-SQL)
                SELECT *
                FROM
                    #{t}
                WHERE
                    #{options}
            SQL
            return nil if data.empty?
            data.map{|datum| self.new(datum)}
        end
    end

    def save
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