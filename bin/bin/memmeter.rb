#!/usr/bin/ruby

def bytesToMeg(bytes)
    if bytes.to_i > (1024*1024)
        bytes = (bytes.to_f/1048576)
        bytes = (bytes * 10**2).round.to_f / 10**2
        bytes = bytes.to_s + '0' if bytes.to_s =~ /\d+\.\d$/
        '  ' + bytes.to_s + 'G'
    else
        bytes = (bytes.to_f/1024)
        bytes = (bytes * 10**2).round.to_f / 10**2
        bytes = bytes.to_s + '0' if bytes.to_s =~ /\d+\.\d$/
        bytes = ' ' + bytes.to_s if bytes.to_s.length == 5
        bytes.to_s + 'M'
    end
end

def spacer(string)
    if string.length > 15
        string = string[0 .. 12] + "  "
    else
        spaces = 16 - string.length
        0.upto(spaces) do
            string += " "
        end
    end
    string
end

input = %x{ps -arcwwwxo "command rss" -m}
counter = 0
total = 0

title = ARGV[0] == "-t" ? ARGV[1] : "Top RAM processes"
print "#{title}\n\n" unless ARGV[0] == "-t" && ARGV[1].nil?

input.split("\n").each {|line|
    if line =~ /^(.*?)\s+(\d{4,})$/
        exit if counter == 5 or total == 10
        puts "#{spacer($1)}#{bytesToMeg($2)}"
        if $2.to_i < 1
            counter += 1
        end
        total += 1
    end
}
