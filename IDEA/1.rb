a=""
(0...128).each do |m|
    case rand
    when 0...0.5
        a[m]="0"
    when 0.5..1
        a[m]="1"
    end
    #print a
end
print a