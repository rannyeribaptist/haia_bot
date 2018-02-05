############################## read comments ##############################

File.open("file1.txt", "r+") do |fh|
  a = 1
  prev = ""
  while(line = fh.gets) != nil
    if line[0..3] == ("Art.") || prev[0..3] == ("Art.")
      output = File.open("artigo " + a.to_s, "w")
      while(line = fh.gets) != nil
        prev = line
        break if line[0..3] == ("Art.")
        # puts "#{line}"
        puts a
        output << line
      end
      output.close
    end
    a = a + 1
  end
end

############################## read articles ##############################

File.open("file1.txt", "r+") do |fh|
  a = 1
  while(line = fh.gets) != nil
    if line.include?("AA..")
      output = File.open("artigo " + a.to_s, "w")
      while(line = fh.gets) != nil
        break if line.include?("..AA")
        # puts "#{line}"
        puts a
        output << line
      end
      output.close
    end
    a = a + 1
  end
end

############################## Other tryies ##############################

# File.open("file1.txt", "r") do |f|
#   f.each_line do |line|
#     while(a = line.gets) != nil
#       puts "#{a}"
#       break if line.include?("..AA")
#     end
#   end
# end

# c = line.index(/..AA/)
# if c != nil
#   puts line
#   if line.index(/AA../)
#     c = nil
#   end
# end

# if line.index(/Art./) == true
#   checker = 1
# end
# until checker == 1
#   puts line
# end
# if line.index(//) == true
#   checker = 0
# end

# a = line.index(/Art. /)
# if a != nil
#   puts line
# end
# a = nil

# a = line.index(/Art. /)
# if a != nil
#   puts line
#   puts ''
# end
# if line.empty?
#   a = nil
# end
