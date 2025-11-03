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
