# encoding: utf-8
require 'logstash/filters/base'
require 'logstash/namespace'

class LogStash::Filters::CSharp < LogStash::Filters::Base
  config_name 'csharp'

  config :type, :validate => ["exception", "stacktrace"], :required => true
  config :source, :validate => :string, :required => true
  config :target, :validate => :string, :required => true

  # stacktrace specific configuration
  config :most_recent_call_last, :validate => :boolean, :default => false # or is it the other way round?
  config :stackframe, :validate => :string, :default =>  '^\s*at (.*)\((.*)\) in (.*):line (\d*)\s*$'
  config :stackframe_separator, :validate => :string, :default => '\n'
  config :stackframe_function, :validate => :string, :default => '^\s*at (.*)\((.*)\)\s*$'
  config :stackframe_path_prefix, :validate => :string

  def parse_stacktrace(stacktrace)
    if stacktrace.nil?
        return { "frames" => [] }
    end
    
    frames = []
    for frame in stacktrace.split(@stackframe_separator)
        begin
            match = @stackframe.match(frame)
            if match
                parsed = {
                    :abs_path => match[3],
                    :function => match[1],
                    :lineno => match[4]
                }
            else
                match = @stackframe_function.match(frame)
                parsed = {
                    :function => match[1]
                }
            end

            if parsed[:abs_path] and @stackframe_path_prefix
                parsed[:filename] = parsed[:abs_path].gsub(@stackframe_path_prefix, '')
            end

            frames << parsed
        rescue Exception => e
            frames << {
                :filename => "failed to parse stack frame: #{e.inspect}",
                :function => frame,
                :lineno => '0'
            }
        end
    end

    frames.reverse! if @most_recent_call_last

    return { "frames" => frames }
  end

  def parse_exception(exception)
    exceptions = []
    if exception['InnerException']
        exceptions.push(*parse_exception(exception['InnerException']))
    end
    exceptions << {
        :type => exception['ClassName'],
        :value => exception['Message'],
        :stacktrace => parse_stacktrace(exception['StackTraceString'])
    }

    exceptions.reverse! if @most_recent_call_last

    return exceptions
  end

  public
  def register
    @stackframe = Regexp.new @stackframe
    @stackframe_separator = Regexp.new @stackframe_separator
    @stackframe_function = Regexp.new @stackframe_function
    @stackframe_path_prefix = Regexp.new @stackframe_path_prefix if @stackframe_path_prefix
  end

  def filter(event)
    begin
      source = event.get(@source)
      if source
        if @type == "stacktrace"
          filtered = parse_stacktrace(source)
        elsif @type == "exception"
          filtered = parse_exception(source)
        else
          logger.warn('Unknown type #{@type}')
          return
        end

        event.set(@target, filtered)
        filter_matched(event)
      end
    end
  end
end
