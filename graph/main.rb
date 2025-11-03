# 野人过河问题

river #遍历出所有状态

$sudi=Sudigraph.new x #赋值给搜索图

(0...$source1.length).each do |m|

    $sudi[m]=Point.new(Hash.new,$source1[m])

end

$sudi.reach! #作出邻接哈希表

$orig={"preacher"=>3,"savage"=>3,"boat"=>1} #起点

$dest={"preacher"=>0,"savage"=>0,"boat"=>0} #终点

$sudi.search($sudi[$source1.index($orig)],$sudi[$source1.index($dest)],Route.new) #搜索

print "搜索完毕，共有#{$sudi.count}条路径。"


def reachForriver(p1,p2)

    if p1["boat"]+p2["boat"]!=1 or p1["savage"]+p1["preacher"]==p2["savage"]+p2["preacher"] #船或者人的情况不符合

        return false

    end

    [p1,p2].each do |m| #是否发生攻击事件？

        if(!(m["preacher"]==0 or m["preacher"]==3) and m["preacher"]!=m["savage"]) 

            #当传教士不在同一岸时，只要有一岸的传教士人数不等于野人的人数，就会发生野人攻击传教士的局面

            #由于我们在生成状态时没有检查，所以对起点与终点都要执行检查 #其实当起点合法时这没有必要

            return false

        end

    end

    change=p1["savage"]-p2["savage"]+p1["preacher"]-p2["preacher"] #这一步变更的人数

    if change.abs>2 #船超载了吗？

        return false

    end

    return true

end