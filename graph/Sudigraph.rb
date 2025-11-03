class Sudigraph < Udigraph #继承无向图类的搜索图类

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

        orig.adjoin.each_key do |m| #寻找所有邻点，再发起一步搜索

            unless r.visited? m #这个点没有访问过

                r.push m

                search(@point[m],dest,Route.new.copy(r))

            end

        end

    end

end