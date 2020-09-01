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
          stackframe_path_prefix => ".*\\/(website\\/)"
        }
      }
    CONFIG

    sample("stacktrace" =>
' at MiaPlaza.Logger.LogEntry..ctor(Level level, Exception exception, String message) in /builds/miaplaza/website/modules/logger/Logger/LogEntry.cs:line 29
  at MiaPlaza.Logger.Log.WriteError(Exception e, String message) in /builds/miaplaza/website/modules/logger/Logger/Log.cs:line 54
  at MiaPlaza.LO.Reminder.<>c__DisplayClass27_0.<CheckToBeDeletedAccounts>b__0() in /builds/miaplaza/website/wwwroot/LO/Reminder.cs:line 676
  at MiaPlaza.Module.Member.AuthenticationMethod.ThreadAuthenticationMethod.SubstituteUserDo(Member member, Action action) in /builds/miaplaza/website/wwwroot/Module/Member/AuthenticationMethod/ThreadAuthenticationMethod.cs:line 35
  at MiaPlaza.LO.Reminder.CheckAll() in /builds/miaplaza/website/wwwroot/LO/Reminder.cs:line 96
  at System.Timers.Timer.MyTimerCallback(Object state)
  at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
  at System.Threading.TimerQueueTimer.CallCallback(Boolean isThreadPool)
  at System.Threading.TimerQueueTimer.Fire(Boolean isThreadPool)
  at System.Threading.TimerQueue.FireNextTimers()') do
      expect(subject.get("stacktrace")).to eq({ "frames" =>
       [{"path"=>'/builds/miaplaza/website/modules/logger/Logger/LogEntry.cs',
         "filename"=>'modules/logger/Logger/LogEntry.cs',
         "lineno"=>"29",
         "function"=>"MiaPlaza.Logger.LogEntry..ctor"},
        {"path"=> '/builds/miaplaza/website/modules/logger/Logger/Log.cs',
         "filename"=> 'modules/logger/Logger/Log.cs',
         "lineno"=>"54",
         "function"=>"MiaPlaza.Logger.Log.WriteError"},
        {"path"=> '/builds/miaplaza/website/wwwroot/LO/Reminder.cs',
         "filename"=> 'wwwroot/LO/Reminder.cs',
         "lineno"=>"676",
         "function"=>"MiaPlaza.LO.Reminder.<>c__DisplayClass27_0.<CheckToBeDeletedAccounts>b__0"},
        {"path"=> '/builds/miaplaza/website/wwwroot/Module/Member/AuthenticationMethod/ThreadAuthenticationMethod.cs',
         "filename"=> 'wwwroot/Module/Member/AuthenticationMethod/ThreadAuthenticationMethod.cs',
         "lineno"=>"35",
         "function"=> "MiaPlaza.Module.Member.AuthenticationMethod.ThreadAuthenticationMethod.SubstituteUserDo"},
        {"path"=> '/builds/miaplaza/website/wwwroot/LO/Reminder.cs',
         "filename"=> 'wwwroot/LO/Reminder.cs',
         "lineno"=>"96",
         "function"=> "MiaPlaza.LO.Reminder.CheckAll"},
        {"function"=>"System.Timers.Timer.MyTimerCallback"},
        {"function"=>"System.Threading.ExecutionContext.RunInternal"},
        {"function"=>"System.Threading.TimerQueueTimer.CallCallback"},
        {"function"=>"System.Threading.TimerQueueTimer.Fire"},
        {"function"=>"System.Threading.TimerQueue.FireNextTimers"}]})
    end
  end
end

