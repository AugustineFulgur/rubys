$LOAD_PATH << '.'
require 'UdiGraph'

def preOrder(udigraph,point) #深度优先遍历一张无向图,point为开始的节点
    if udigraph.findall?
        return 
    end
    if point==false
        return
    end
    print point.value #输出节点的值，并标记此节点为访问过
    point.visited=true
    (0...point.neighbor).each do 
        preOrder(udigraph,udigraph.next(point.id)) #找到下一个相邻的点然后继续遍历

    end
end

def levOrder(udigraph,point) #广度优先遍历
    queue=Queue.new
    queue.push point #起点入栈
    while !queue.empty? do
        top=queue.front #取出一个节点
        top.visited=true
        print top.value
        queue.pop
        loop do #当其还有邻节点时
            next_=udigraph.next(top.id)
            if next_==false
                break "break"
            else
                next_.visited=true #进入队列了就是被访问了
                queue.push next_ #将其邻节点入队
            end
        end
    end
end


#赋值部分---------------------------------------------------------------------------------------------------------------
'''
source1=[1,2,3,4,5] #节点值
source2=[{2=>1,3=>1,4=>1,1=>1},{0=>1,2=>0,3=>0,4=>0},{0=>1,1=>0,3=>1,4=>1},{0=>1,1=>0,2=>1,4=>0},{0=>1,1=>0,2=>1,3=>0}]
$udi=Udigraph.new
(0...5).each do |m|
    $udi[m]=Point.new(source2[m],source1[m])
end

preOrder($udi,$udi[0])
levOrder($udi,$udi[0])
'''

STICK=[0,1,2,3,4,5,6,7,8]
$source1=Array.new 
def all8(step,stick,p) #步数，已使用过的数组，目前的状态
    if step==9 #穷举完了，返回
        $source1.push p
        return
    else
        STICK.each do |s| #对每个可以选取的元素调用all8
            unless stick.index s #这个元素还未被选取
                all8(step+1,stick+[s],p+s.to_s) #进一步遍历
            end
        end
    end
end

#all8(0,[],"")
#p $source1.length

def reachFor8num(p1,p2) #八数码问题的reach方法
    index=p1.index "0"
    p=[]
    [0,2,4,8].each do |m| #四方向移动 #这里使用块传递会更好些，但是为了扩展性我们直接写出来
        box=String.new p1 #使用拷贝值，防止更改
        case m
        when 8
            if index>2
                a=box[index-3]
                box[index-3]=box[index]
                box[index]=a
            end
        when 2
            unless [0,3,6].index index 
                a=box[index-1]
                box[index-1]=box[index]
                box[index]=a
            end
        when 4
            unless [2,5,8].index index
                a=box[index+1]
                box[index+1]=box[index]
                box[index]=a
            end
        when 0
            if index<6
                a=box[index+3]
                box[index+3]=box[index]
                box[index]=a
            end
        end
        p.push box #可移动情况下压入移动后的状态
    end
    p.compact! #去除nil元素
    p.each do |m|
        if m==p2
            return true
        end
    end
    return false
end

#p reachFor8num("012345678","10236578")

def river
    re=Array.new
    (0..3).each do |m|
        (0..3).each do |n|
            (0..1).each do |i|
                re.push({"savage"=>m,"preacher"=>n,"boat"=>i}) #一个关于野人、传教士、船的字典
            end
        end
    end
    $source1=re #赋给全局变量source1，之后由其实例化节点
end

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

#p reachForriver({"boat"=>1,"savage"=>1,"preacher"=>3},{"boat"=>0,"savage"=>1,"preacher"=>2})
x='''
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
'''

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
