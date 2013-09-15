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

