
module Starter
  module Misc

    def marshalize(filename, &block)
      if File.exist?(filename)
        File.open(filename) { |f| Marshal.load(f) }
      elsif File.exist?(filename + ".gz")
        system "gunzip #{filename}.gz"
        File.open(filename) { |f| Marshal.load(f) }
      else
        val = yield
        File.open(filename, "w") do |f|
          Marshal.dump(val, f)
        end
        val
      end
    end


  end
end
