require 'logstash/devutils/rspec/spec_helper'
require 'logstash/filters/csharp'

describe LogStash::Filters::CSharp do
  describe "Parse C# Stacktraces" do
    config <<-CONFIG
      filter {
        csharp {
          type => "stacktrace"
          source => [stacktrace]
          target => [stacktrace]
          stackframe_path_prefix => ".*\\\\(?=prod\\\\)"
        }
      }
    CONFIG

    sample("stacktrace" =>
' at MiaPlaza.Logger.LogEntry..ctor(Level level, Exception exception, String message) in D:\build\src\previous1199\prod\core\Logger\LogEntry.cs:line 29
  at MiaPlaza.LO.LongtimeJobScheduler.run(Job job) in D:\build\src\previous1199\prod\wwwroot\LO\LongtimeJobScheduler.cs:line 263
  at MiaPlaza.LO.LongtimeJobScheduler.executeNextJob() in D:\build\src\previous1199\prod\wwwroot\LO\LongtimeJobScheduler.cs:line 231
  at MiaPlaza.LO.LongtimeJobScheduler.<>c__DisplayClass24_0.<initializePeriodicJobScheduling>b__0(Object source, ElapsedEventArgs e) in D:\build\src\previous1199\prod\wwwroot\LO\LongtimeJobScheduler.cs:line 195
  at System.Timers.Timer.MyTimerCallback(Object state)
  at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state, Boolean preserveSyncCtx)
  at System.Threading.ExecutionContext.Run(ExecutionContext executionContext, ContextCallback callback, Object state, Boolean preserveSyncCtx)
  at System.Threading.TimerQueueTimer.CallCallback()
  at System.Threading.TimerQueueTimer.Fire()
  at System.Threading.TimerQueue.FireNextTimers()') do
      expect(subject.get("stacktrace")).to eq({ "frames" =>
       [{"abs_path"=>'D:\build\src\previous1199\prod\core\Logger\LogEntry.cs',
         "filename"=>'prod\core\Logger\LogEntry.cs',
         "lineno"=>"29",
         "function"=>"MiaPlaza.Logger.LogEntry..ctor"},
        {"abs_path"=> 'D:\build\src\previous1199\prod\wwwroot\LO\LongtimeJobScheduler.cs',
         "filename"=> 'prod\wwwroot\LO\LongtimeJobScheduler.cs',
         "lineno"=>"263",
         "function"=>"MiaPlaza.LO.LongtimeJobScheduler.run"},
        {"abs_path"=> 'D:\build\src\previous1199\prod\wwwroot\LO\LongtimeJobScheduler.cs',
         "filename"=> 'prod\wwwroot\LO\LongtimeJobScheduler.cs',
         "lineno"=>"231",
         "function"=>"MiaPlaza.LO.LongtimeJobScheduler.executeNextJob"},
        {"abs_path"=> 'D:\build\src\previous1199\prod\wwwroot\LO\LongtimeJobScheduler.cs',
         "filename"=> 'prod\wwwroot\LO\LongtimeJobScheduler.cs',
         "lineno"=>"195",
         "function"=> "MiaPlaza.LO.LongtimeJobScheduler.<>c__DisplayClass24_0.<initializePeriodicJobScheduling>b__0"},
        {"function"=>"System.Timers.Timer.MyTimerCallback"},
        {"function"=>"System.Threading.ExecutionContext.RunInternal"},
        {"function"=>"System.Threading.ExecutionContext.Run"},
        {"function"=>"System.Threading.TimerQueueTimer.CallCallback"},
        {"function"=>"System.Threading.TimerQueueTimer.Fire"},
        {"function"=>"System.Threading.TimerQueue.FireNextTimers"}]})
    end
  end
end

