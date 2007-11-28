require 'transat/parser'

module Thin
  def self.define_commands(&block)
    begin
      Transat::Parser.parse_and_execute(ARGV, &block)      
    rescue CommandError => e
      puts "Error: #{e}"
    end
  end
  
  class CommandError < StandardError; end
  
  class Command
    attr_reader :args
  
    def initialize(non_options, options)
      @args = non_options

      options.each do |option, value|
        self.send("#{option}=", value)
      end
    end
    
    def self.command_name
      self.name.match(/::(\w+)$/)[1].downcase
    end
    
    def self.detailed_help
      <<-EOF
usage: #{File.basename($PROGRAM_NAME)} #{command_name}

#{help}
EOF
    end
    
    protected
      def error(message)
        raise CommandError, message
      end
  end
  
  module Commands; end
  Dir[File.dirname(__FILE__) + '/commands/**/*.rb'].each { |l| require l }
end