class Queue #队列类，用于广度优先遍历

    def initialize

        @data=[]

        @length=-1

    end

    def push(data)

        @length=@length+1 #自加

        @data[@length]=data

    end

    def front

        if @length<0

            return false

        end

        return @data[0]

    end

    def pop 

        if @length<0

            return false

        end

        if @length==0

            @data=[]

        else

            @data=@data[1..@length]

        end

        @length=@length-1

    end

    def size

        return @length+1

    end

    def empty?

        return @length==-1?true:false

    end

    def ergodic #用于测试的方法

        p @data

    end

end