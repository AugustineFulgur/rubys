def i16to2(str)
    re=""
    (0...str.length/2).each do |m|
        x=str[0+m*2..1+m*2].to_i(16).to_s(2)
        if(x.length<8)
            y=""
            (0...8-x.length).each do 
                y+="0"
            end
            y+=x
            x=y
        end
        re+=x
    end
    print re
end

p "start"
i16to2 gets.chomp 