#!/usr/local/bin/ruby

def make_matrix( m, n )
  matrix = Array.new( m ).map{ Array.new( n ) }
  for i in 0..m - 1
    for j in 0..n - 1
      matrix[i][j] = rand 10
    end
  end
  matrix
end

matrix_a =  make_matrix 75, 75
matrix_b =  make_matrix 75, 75
pids = []
read, write = IO.pipe

t0 = Time.now
matrix_a.each_with_index do |vector_a, i|
#  pids << fork do
    results = []
    matrix_b.each do |vector_b|
      sum = 0
      vector_a.each do |cell_a|
        vector_b.each do |cell_b|
          sum += cell_a * cell_b
        end
      end
      results.push sum
    end
    write.puts "#{i},#{results.join ','}"
#  end
end
results = Process.waitall
t1 = Time.now

write.close
order = []
read.read.split.map { |str| order.push str.split( ',' )[0] }
order.each_slice( 5 ).each do |enum|
  puts enum.to_a.join( "\t" )
end
read.close

puts "#{t1 - t0} sec"
