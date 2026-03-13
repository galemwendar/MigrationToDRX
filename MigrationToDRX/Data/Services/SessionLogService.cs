using NLog;
using NLog.Config;
using NLog.Targets;

namespace MigrationToDRX.Data.Services;

/// <summary>
/// Сервис для управления сессионным файлом логов.
/// При каждом вызове StartNewSession() создаётся новый файл лога в папке logs с именем по формату даты-времени.
/// </summary>
public class SessionLogService
{
    private FileTarget? _sessionTarget;
    private LoggingRule? _sessionRule;
    private readonly object _lock = new();

    /// <summary>
    /// Начинает новую сессию логирования — создаёт новый файл лога с именем по текущей дате и времени.
    /// </summary>
    public void StartNewSession()
    {
        lock (_lock)
        {
            var config = LogManager.Configuration;
            if (config == null) return;

            // Удаляем предыдущий сессионный target, если существует
            if (_sessionRule != null)
            {
                config.LoggingRules.Remove(_sessionRule);
                _sessionRule = null;
            }

            if (_sessionTarget != null)
            {
                config.RemoveTarget("session_file");
                _sessionTarget.Dispose();
                _sessionTarget = null;
            }

            var logDir = Path.Combine(AppContext.BaseDirectory, "logs");
            Directory.CreateDirectory(logDir);

            var filename = DateTime.Now.ToString("yyyy-MM-dd_HH-mm-ss") + ".log";
            var filePath = Path.Combine(logDir, filename);

            _sessionTarget = new FileTarget("session_file")
            {
                FileName = filePath,
                Layout = "${longdate}|${uppercase:${level}}|${logger}|${message} ${exception:format=tostring}",
                KeepFileOpen = true
            };

            config.AddTarget(_sessionTarget);

            _sessionRule = new LoggingRule("*", NLog.LogLevel.Info, NLog.LogLevel.Fatal, _sessionTarget);
            config.LoggingRules.Add(_sessionRule);

            LogManager.ReconfigExistingLoggers();
        }
    }
}
