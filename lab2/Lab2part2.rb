class Class
  def attr_accessor_with_history(attr_name)
    attr_name = attr_name.to_s
    attr_reader attr_name
    attr_reader attr_name+"_history"
    class_eval %Q{
      def #{attr_name}=(attr_name)
        @#{attr_name} = attr_name

        unless @#{attr_name+"_history"}
          @#{attr_name+"_history"} = Array.new
          @#{attr_name+"_history"} << nil
        end
        @#{attr_name+"_history"} << attr_name
      end
    }
  end
end

class Foo
  attr_accessor_with_history :bar
end

class Numeric
 @@currencies = {'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019, 'dollar' => 1}
 def method_missing(method_id)
   singular_currency = method_id.to_s.gsub( /s$/, '')
   if @@currencies.has_key?(singular_currency)
     self * @@currencies[singular_currency]
   else
     super
   end
 end
 def in(conRate)
   conRate = conRate.to_s.gsub( /s$/, '')
   self / @@currencies[conRate]
 end
end

class String
  def palindrome?
    string = self.to_s.downcase.gsub(/[^a-zA-Z]/, '')
    string === string.reverse
  end
end

module Enumerable
  def palindrome?
    self == self.reverse_each.map {|v| v}
  end
end

class CartesianProduct
  include Enumerable
  def initialize(arry1=[], arry2=[])
    @arry1 = arry1
    @arry2 = arry2
  end
  def each
    @arry1.each do |n|
      @arry2.eac do |z|
        yield ([n, z])
      end
    end
  end
end

c = CartesianProduct.new([:a,:b][4,5])
c.each {|elt| p elt.inspect}
=begin
p [1,2,3,2,1].palindrome?
p [1,2,3,4,5].palindrome?
test = {"Jane Doe" => "10", "Johnny B" => "5"}
p test.palindrome?

p "foo".palindrome?
p "level".palindrome?
p "A man, a plan, a canal -- Panama".palindrome?
p "madam, I'm Adam!".palindrome?
p "Abracadabra".palindrome?

p 5.dollars.in(:euros)
p 5.euros.in(:rupees)
p 5.rupees.in(:dollars)
p 5.yen.in(:yen)


f = Foo.new
f.bar = 1
f.bar = 2
p f.bar_history
f = Foo.new
f.bar = 1
p f.bar_history

=end
