module Comet
  module DSL
    module IncludeWalker
      class << self
        def includes_for(file, include_paths)
          @@cache[[file, include_paths]]
        end

        def search(file, include_paths)
          includes = []

          File.read(file).scan(PATTERN) do
            header = Regexp.last_match[1] || Regexp.last_match[2]
            includes << find_included_file(header, include_paths)
          end

          includes.compact.uniq.dup.each do |included|
            includes.concat search(included, include_paths)
          end

          includes.compact.uniq
        end

        private

        @@cache = Hash.new do |h, k|
          h[k] = IncludeWalker.search(*k)
        end

        PATTERN = /^\s*#\s*include\s*(?:(?:<([^>]+)>)|(?:"([^"]+)"))\s*$/m

        def find_included_file(file, include_paths)
          match = include_paths.detect do |include_path|
            File.exist? File.join(include_path, file)
          end

          File.join(match, file) unless match.nil?
        end
      end
    end
  end
end
