module Starter

  class Markdown


    #Extender.process(
      #:file => "path/to/template.md",
      #:output => "path/to/output.md"
    #)
    #new_string = Extender.process(string)

    module Extender

      def self.process(arg)
        if arg.is_a? String
          string = arg
          options = {}
        else
          options = arg
          string = File.read arg[:file]
        end
        lines = string.split("\n")
        out = FootnoteProcessor.new.process(lines)
        out = CodeEmbedder.new.process(out)

        processed = out.join("\n")
        if path = options[:output]
          File.open path, "w" do |f|
            f.puts processed
          end
        end
        processed
      end

    end

    class CodeEmbedder
      def initialize(options={})
        @regex = %r{^```([^\s#]+)(#L(\S+))?\s*```$}
      end


      def process(lines)
        # TODO: handle URLs
        out = []
        lines.each do |line|
          if md = @regex.match(line)
            _full, source_path, badline, line_spec = md.to_a
            if line_spec
              start, stop = line_spec.split("-").map { |s| s.to_i}
            else
              start = 1
            end

            source_path = File.expand_path(source_path).strip
            extension = File.extname(source_path)
            out << "```#{extension}"

            embed = []
            File.open(source_path, "r") do |source|
              source.each_line do |line|
                embed << line
              end
            end
            start -= 1
            if stop
              stop -=1
            else
              stop = embed.size - 1
            end
            out << embed.slice(start..stop).join()
            out << "```\n"
          else
            out << line
          end
        end
        out
      end

    end

    # Converts Pandoc-style footnotes into appropriate HTML
    class FootnoteProcessor

      def initialize(options={})
        # looking for footnote refs like [^some_identifier]
        @note_regex = /
          ^
          \[\^
            ([\d\w\-_]+)
          \]:
        /x
        @ref_regex = /
          \[\^
            ([\d\w\-_]+)
          \]
        /x
      end
      
      def process(lines)
        out = []
        refs = []
        notes = {}
        ref_counter = 0
        while line = lines.shift
          if md = @note_regex.match(line)
            full, identifier = md.to_a
            note = notes[identifier] = [line]
            while (next_line = lines.shift) && next_line !~ /^\s*$/
              note << next_line
            end

          elsif md = @ref_regex.match(line)
            full, identifier = md.to_a
            ref_counter += 1
            refs << identifier
            out << line.sub(full, format_ref(ref_counter, identifier))
          else
            out << line
          end
        end

        if refs.size > 0
          out << ""
          out << "# Notes"
          out << ""
          refs.each_with_index do |identifier, index|
            if note = notes[identifier]
              start = note.shift
              anchor = format_anchor(index + 1, identifier)
              start.sub! /^\[.*\]: /, ""
              out << "#{anchor} #{start}"

              note.each do |line|
                out << line
              end
              out << ""
            end
          end
        end
        out << ""
        out
      end


      def format_anchor(number, identifier)
        %Q{<a name="#{identifier}" href="#__#{identifier}">#{number} &#8617;</a>.}
      end

      def format_ref(number, identifier)
        %Q{
          <sup><a name="__#{identifier}" href="##{identifier}">#{number}</a>.</sup>
        }.strip
      end
    end

  end
end
