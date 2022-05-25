module Rightmove
  class MapImporter
    def initialize(parallelism: 3)
      @sections = Section.where(consider: true).where("lastrun IS NULL OR lastrun < ?", 1.month.ago).to_a.shuffle
      @queue = Queue.new

      @sections.each do |s|
        @queue << s
      end

      @parallelism = parallelism
    end

    def run
      threads = @parallelism.times.map do
        Thread.new do
          loop do
            begin
              section = @queue.pop(true)
            rescue ThreadError
              break
            end
            break unless section

            section.reload
            if section.lastrun.nil? || section.lastrun < 1.month.ago
              import_section(section)
            end
          end
        end
      end

      threads.map(&:join)
    end

    def import_section(section)
      SectionImporter.new(section: section).import

      # remove disappeared properties
      # section.properties.where("updated_at < 1.week.ago").delete_all
    end
  end
end
