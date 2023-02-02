=begin
       user     system      total        real
Ruby...  0.134969   0.000438   0.135407 (  0.135889)
Crystal  0.022052   0.000056   0.022108 (  0.022191)

       user     system      total        real
Ruby...  0.138580   0.000870   0.139450 (  0.140358)
Crystal  0.022503   0.000037   0.022540 (  0.022577)

       user     system      total        real
Ruby...  0.138442   0.000620   0.139062 (  0.139794)
Crystal  0.022758   0.000289   0.023047 (  0.023337)

       user     system      total        real
Ruby...  0.136729   0.000670   0.137399 (  0.138316)
Crystal  0.022129   0.000073   0.022202 (  0.022280)

       user     system      total        real
Ruby...  0.146873   0.000792   0.147665 (  0.148586)
Crystal  0.022721   0.000174   0.022895 (  0.023197)

       user     system      total        real
Ruby...  0.138691   0.000218   0.138909 (  0.139111)
Crystal  0.021689   0.000071   0.021760 (  0.021795)
=end

require "benchmark"
require "./crystal"

class Ruby
  def summation(n)
    n < 2 ? n : n + summation(n - 1)
  end
end

ruby = Ruby.new
crystal = Crystal.new

number = 1000
many = 5_000

Benchmark.bm do |bm|
  bm.report("Ruby...") do
    many.times { ruby.summation(number) }
  end

  bm.report("Crystal") do
    many.times { crystal.summation(number) }
  end
end

true

