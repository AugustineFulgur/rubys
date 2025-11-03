class Udigraph #无向图的类，本类的实例表示一个无向图
    attr_accessor :point #Point
    
    def initialize
        @point=Hash.new
    end

    def [](id) #重载 #这里的id与point的id同步
        if @point[id]!=nil
            return @point[id]
        else
            return false
        end
    end

    def []=(id,point) 
        @point[id]=point
        point.id=id
        return
    end

    def length
        return @point.length
    end

    def find(id) #查找图中的节点
        @point.each do |m|
            if m.id=id
                p m.id
                return m
            end
        end
    end

    def findall? #这个图里的所有节点都访问过了？
        @point.each_key do |m|
            unless @point[m].visited?
                return false
            end
        end
        return true
    end

    def next(id) #返回第一个相邻的未访问的节点
        @point.keys.each do |i|
            unless @point[i].visited? #此节点未被访问
                if @point[i].neighbor? id
                    return @point[i]
                end
            end
        end
        return false
    end

end
