require "starter/extensions/module"
module Starter
  module Mixins
  
    module Stats
      
      def self.summary(items)
        sorted = items.sort
        [
          [:mean, sorted.mean],
          [:stddev, sorted.standard_deviation],
          [:min, sorted.first],
          [:q1, sorted._quartile(1)],
          [:median, sorted._median],
          [:q3, sorted._quartile(3)],
          [:max, sorted.last],
          [:sample_size, sorted.size]
        ]
      end

      def self.sum(items)
        s = 0; items.each { |element| s += element }; s
      end
      
      def self.mean(items)
        items.sum.to_f / items.size
      end
      
      def self.variance(items)
        denom = items.size - 1
        m = items.mean
        s = 0
        items.each { |element| s += (element - m)**2; }
        s / denom
      end
      
      def self.standard_deviation(items)
        Math.sqrt( items.variance )
      end
      
      def self.median(items)
        self._median(items.sort)
      end

      def self.quartile(items, n)
        raise ArgumentError unless n > 0 && n < 4
        self._quartile(items.sort, n)
      end

      private

      def self._quartile(sorted, n)
        s = sorted.size
        sorted[n * s/4]
      end

      def self._median(sorted)
        s = sorted.size
        i = s % 2
        case i
         when 0 then sorted[s/2 - 1, 2].mean
         when 1 then sorted[s/2].to_f
        end if sorted.size > 0
      end

      Starter::Extensions::Module.create_instance_methods(self)

    end
    
  end
end

