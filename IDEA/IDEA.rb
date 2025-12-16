#---------------------------------------------------------------------------
#IDEA算法的类
#---------------------------------------------------------------------------
class IDEA

#----------------------------------------------
#全局变量范围
#----------------------------------------------
    $adcipher="" #表示用户输入的密钥，为128位二进制
    $cipher=Array.new 52 #根据用户输入算出的最终加密密钥
    $decipher=Array.new 52 #通过$cipher与reverse算出的解密密钥
    $shift=25 #密钥移位的位数
    $adtext="" #表示用户输入的64位二进制，可以是明文，也可以是密文
#-----------------------------------------------
#方法范围
#-----------------------------------------------

    def leftshift(binary) #左移$shift位
        return binary[$shift...binary.length]+binary[0...$shift]
    end
    
    def tocipher #算出52组密钥
        re=Array.new 56
        cipher=$adcipher
        (0...7).each do |n| #左移
            unless n==0 #第一次不用左移
                cipher=leftshift cipher
            end
            (0...8).each do |m| #密钥组分割成八份
                re[n*8+m]=cipher[0+m*16...16+m*16]
            end
        end
        $cipher=re[0...52] #算出了56个，但是只有前52个会被使用
    end

    def to16!(num) #将数字转换为16位二进制字符串（多余舍去） 
        str=num.to_s 2
        if str.length>16 #取后十六位
            return str[str.length-16...str.length]
        end
        re=""
        (0...16-str.length).each do
            re+="0"
        end
        return re+str 
    end

    def multi(str1,str2) #模乘法（返回字符串） #模乘在乘数为0时视为65536
        a=str1.to_i 2
        b=str2.to_i 2
        if a==0
            a=65536
        end
        if b==0
            b=65536
        end
        return to16! (str1.to_i(2)*str2.to_i(2))%65537
    end

    def plus(str1,str2) #模加法（返回字符串）
        return to16! str1.to_i(2)+str2.to_i(2)
    end

    def xor16(str1,str2) #十六位异或
        re=""
        (0...16).each do |m|
            re+=(str1[m].to_i^str2[m].to_i).to_s
        end
        return re
    end

    def code #加解密过程
        text=Array.new 4 #明文组
        (0...4).each do |m| #切割最开始的明文为长度16的四块
            text[m]=$adtext[0+m*16...16+m*16]
        end
        (0...8).each do |round| #八轮相同的运算
            #puts text
            step1=multi text[0],yield(0+6*round) #相乘 一次循环用六个密钥
            step2=plus text[1],yield(1+6*round) #相加 
            step3=plus text[2],yield(2+6*round) #相加
            step4=multi text[3],yield(3+6*round) #相乘
            step5=xor16 step1,step3 #异或 #vscode的上色真傻，但这不是它的错
            step6=xor16 step2,step4 #异或
            step7=multi step5,yield(4+6*round) #相乘
            step8=plus step6,step7 #相加
            step9=multi step8,yield(5+6*round) #相乘
            step10=plus step7,step9 #相加
            step11=xor16 step1,step9 #异或
            step12=xor16 step2,step10 #异或
            step13=xor16 step3,step9 #异或
            step14=xor16 step4,step10 #异或
            text[0]=step11 #覆盖之前的输入，中间两组交换
            text[1]=step13
            text[2]=step12
            text[3]=step14
            (1..14).each do |m|
                eval("puts 'step"+m.to_s+":'+step"+m.to_s)
            end
        end
        out=Array.new 4 #输出的密文
        out[0]=multi text[0],yield(48) #将中间两个分组交换回来
        out[1]=plus text[2],yield(49)
        out[2]=plus text[1],yield(50)
        out[3]=multi text[2],yield(51)
        re=""
        out.each do |a| #拼接密文
            re+=a
        end
        return re
    end

    $x=-1
    $y=-1
    def euclid(a,b) #扩展欧几里得，本方法在Minverse内部调用
        if b==0
            $x=1
            $y=0
            return
        end
        euclid b,a%b
        k=$x
        $x=$y
        $y=k-a/b*$y
    end

    def Minverse(str) #求16位二进制字符串的模乘法逆元 
        #由于涉及的数字比较大我们用扩展欧几里得算 #不过感觉好像也没有太大
        #而我们知道，Z65536*是一个群，所以str.to_i必然与65537互质
        mod=2**16+1
        num=str.to_i 2
        if num==0
            num=65536
        end
        euclid num,mod
        return to16! ($x%mod+mod)%mod
    end

    def Pinverse(str) #求16位二进制字符串的模加法逆元
        plu=2**16
        num=str.to_i 2
        return to16! plu-num
    end

    def reverse #将密钥从加密变成解密
        #我们先把$cipher中的密钥分别切割到$decipher，然后根据其类型分别取逆元
        (0..8).each do |m|
            de=(8-m)*6 #逆转变量
            c=m*6
            if m==0 or m==8 #第一轮和最后一轮的前四个密钥不需要移动
                $decipher[de+0...de+4]=$cipher[c+0...c+4]
            else
                $decipher[de+0]=$cipher[c+0] #交换中部两个密钥
                $decipher[de+1]=$cipher[c+2]
                $decipher[de+2]=$cipher[c+1]
                $decipher[de+3]=$cipher[c+3]
            end
            if m==0 #最后一轮没有最后两个密钥，直接跳出
                next
            end
            $decipher[de+4]=$cipher[c-2]
            $decipher[de+5]=$cipher[c-1] #后两个密钥
        end
        mark="" #标记数组
        (0...8).each do 
            mark+="{[[{((" #后两个乘法不用求逆元
        end
        mark+="{[[{" 
        (0...52).each do |m|
            case mark[m]
            when "{"
                $decipher[m]=Minverse $decipher[m]
            when "["
                $decipher[m]=Pinverse $decipher[m]
            end
        end
    end

    def ui 
        puts "请输入密钥："
        $adcipher=gets.chomp 
        tocipher #转换到密钥
        reverse #转换到解密密钥
        puts $decipher
        #puts "/"
        #puts $cipher
        loop do
            puts "加密还是解密？（t/f，跳出循环按c）"
            jump=gets[0] #加密/解密/跳出:t/f/c
            puts "请输入待处理的文字：（跳出就不填）"
            $adtext=gets.chomp 
            case jump
            when "t"
                puts code {|m| $cipher[m]}
            when "f"
                puts code {|m| $decipher[m]}
            when "c"
                return
            end
        end
    end

end
