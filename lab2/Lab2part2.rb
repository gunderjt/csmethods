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

f = Foo.new
f.bar = 1
f.bar = 2
p f.bar_history
f = Foo.new
f.bar = 1
p f.bar_history

