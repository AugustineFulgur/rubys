class Route #搜索路线的类

    #对于这个类，我并不会试图去回溯它，而是在情况出现分歧的时候复制它

    attr_accessor :route

    attr_accessor :step

    def initialize

        @route=[] #路线，为Point的数组，其下标为步数

        @step=0 #长度

    end

    def copy(cp) #复制

        @route=Array.new cp.route

        @step=cp.step

        return self

    end

    def push(data) #加入一个新状态

        @route[@step]=data

        @step=@step+1

    end

    def visited?(id) #id所属的点是否在路径内（被访问过）

        if @route.index(id)

            return true

        end

        return false

    end

    def say #输出路线

        @route.each do |m|

            print m,"=>"

        end

        puts "end"

    end

end