class Point #无向图节点的类，本类的实例表示一个无向图中的结点
    attr_accessor :adjoin #邻接表 1为相邻 0为不相邻 #这是一张哈希表
    attr_accessor :value #值
    attr_accessor :id #编号 从0开始 #没有被加入进无向图的节点编号为-1
    attr_accessor :visited #访问过与否

    def initialize(adj,val)
        @adjoin=adj
        @value=val
        @visited=false
        @id=-1
    end

    def visited? #访问过了？
        return @visited
    end

    def neighbor?(id) #是否与节点id是邻居？
        if adjoin[id]==1
            return true
        else
            return false
        end
    end

    def neighbor #邻节点个数
        count=0
        @adjoin.each_key do |m|
            if(@adjoin[m]==1) then
                count=count+1
            end
        end
        return count
    end
end

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
        puts "get"
    end

end

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
        #p id
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

class Sudigraph<Udigraph #继承无向图类的搜索图类
    attr_reader :count

    def initialize(reach) #reach是提供给搜索图的判定可达方法
        @reach=reach #reach是一个判断p1是否能一步到达p2的方法 
        @point=Hash.new
        @count=0 #可达的路径数目
    end

    def reach?(p1,p2)
        eval @reach
    end

    def reach!
        @point.values.each do |i|
            @point.values.each do |m|
                unless i==m #排除遍历到自己的时候
                    if reach? i.value,m.value #可达的情况下，加入邻接数组
                        i.adjoin[m.id]=1
                    end
                end
            end
        end
    end
    #reach! #确定所有点的连接性

    def search(orig,dest,r) #这是广度优先搜索
        if (orig.value==dest.value) #抵达终点
            r.say #输出路径
            @count=@count+1 
        end    
        if r.step==1
            p orig.value
            p dest.value
            p r
        end
        orig.adjoin.each_key do |m| #寻找所有邻点，再发起一步搜索
            unless r.visited? m #这个点没有访问过
                r.push m
                search(@point[m],dest,Route.new.copy(r))
            end
        end
    end

end




