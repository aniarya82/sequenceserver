require_relative 'constants'
require_relative 'exceptions'

module SequenceServer

  #BLAST module
  module BLAST
    class Error
      class << self
        alias_method :check, :new
      end
      def initialize(job)
        @job = job
        call_error
      end

      attr_reader :job

      def call_error
        efile = File.readlines(job.efile)
        if job.exitstatus == 1 # error in query sequence or options; see [1]
          egrep = efile.grep(ERROR_LINE)
          error = egrep.join
          error = efile if egrep.empty?
          fail ArgumentError, error
        end
        fail RuntimeError.new(job.exitstatus, efile)
      end
    end

  end
end

# References
# ----------
# [1]: http://www.ncbi.nlm.nih.gov/books/NBK279677/
