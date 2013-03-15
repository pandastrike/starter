require "pathname"
require "term/ansicolor"

module Starter

  class Markdown

    # From http://stackoverflow.com/questions/9268407/how-to-convert-markdown-style-links-using-regex
    InlineLinkRegex = %r{
      \[         # Literal opening bracket
        (        # Capture what we find in here
          [^\]]+ # One or more characters other than close bracket
        )        # Stop capturing
      \]         # Literal closing bracket
      \(         # Literal opening parenthesis
        (        # Capture what we find in here
          [^)]+  # One or more characters other than close parenthesis
        )        # Stop capturing
      \)         # Literal closing parenthesis
    }x

    LinkDefRegex= %r{^\[(.+)\]:(.+)$}

    attr_reader :linted_docs

    def initialize(root_doc, options={})
      @linted_docs = {}
      @root_doc = root_doc
      @directory = options[:directory]
    end

    def lint
      lint_doc(@root_doc)
      if @directory
        files = Dir["#{@directory}/**/*.md"]
        unseen = files.to_a - @linted_docs.keys
        puts Term::ANSIColor.yellow("Unreferenced documents:")
        unseen.each do |path|
          puts "    " + Term::ANSIColor.yellow(path)
        end
      end
    end

    def lint_doc(path, source=nil)
      # no point in repeating a check
      return if @linted_docs[path]

      begin
        string = File.read(path)
        puts "    Linting doc: #{path}"
        lint_markdown(string, path)
        @linted_docs[path] = true
      rescue Errno::ENOENT
        puts Term::ANSIColor.red("Broken link in #{source}: #{path}")
      rescue => e
        pp e
      end
    end


    def lint_markdown(string, source=nil)
      string.each_line do |line|
        normal_link = InlineLinkRegex.match(line)
        link_def = LinkDefRegex.match(line)
        if normal_link
          lint_link(normal_link, source)
        end
        if link_def
          lint_link(link_def, source)
        end
      end
    end

    def lint_link(match, source)
      _m, text, url = match.to_a
      if url && url =~ /\.md$/ && url !~ /^https?:\/\/|#/
        url = (Pathname.new(source).dirname + url).to_s
        url.sub!(/#.*$/, "")
        lint_doc(url, source)
      end
    end

    def gfm_toc(string)
      toc = []
      string.each_line do |line|
        regex = %r{^(\#{1,8})\s+(.+)$}
        if match = regex.match(line)
          _all, hashes, text = match.to_a
          depth = hashes.size - 1
          text = text.strip
          anchor = text.downcase.gsub(/[\s]+/, "-").tr(":`", "")
          puts anchor.inspect
          toc << ("    " * depth) + "* [#{text}](##{anchor})"
        end
      end
      toc.join("\n") + "\n\n" + string
    end

  end

end
