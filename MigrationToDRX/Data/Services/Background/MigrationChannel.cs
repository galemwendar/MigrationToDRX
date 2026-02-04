using System.Threading.Channels;
using MigrationToDRX.Data.Services.Settings;

namespace MigrationToDRX.Data.Services.Background;

/// <summary>
/// Данные задачи миграции для передачи в фоновый сервис
/// </summary>
public class MigrationTask
{
    /// <summary>
    /// Уникальный идентификатор задачи
    /// </summary>
    public Guid Id { get; set; } = Guid.NewGuid();

    /// <summary>
    /// Настройки этапов для выполнения
    /// </summary>
    public List<SettingStage> Stages { get; set; } = new();

    /// <summary>
    /// Время создания задачи
    /// </summary>
    public DateTime CreatedAt { get; set; } = DateTime.Now;
}

/// <summary>
/// Канал для передачи задач миграции в фоновый сервис (Singleton)
/// </summary>
public class MigrationChannel
{
    private readonly Channel<MigrationTask> _channel;

    public MigrationChannel()
    {
        // Unbounded - без ограничения размера очереди
        // Можно заменить на CreateBounded для ограничения
        _channel = Channel.CreateUnbounded<MigrationTask>(new UnboundedChannelOptions
        {
            SingleReader = true, // Один читатель (BackgroundService)
            SingleWriter = false // Несколько писателей (разные пользователи)
        });
    }

    /// <summary>
    /// Писатель для добавления задач в очередь
    /// </summary>
    public ChannelWriter<MigrationTask> Writer => _channel.Writer;

    /// <summary>
    /// Читатель для получения задач из очереди
    /// </summary>
    public ChannelReader<MigrationTask> Reader => _channel.Reader;
}
