using System.IO.Pipes;
using System.Text.Json;


namespace node_core.Services;

public class DockerService
{
    private readonly HttpClient httpClient;

    public DockerService()
    {
        var handler = new SocketsHttpHandler
        {
            ConnectCallback = async (_, cancellationToken) =>
            {
                var stream = new NamedPipeClientStream(
                    ".",
                    "dockerDesktopLinuxEngine",
                    PipeDirection.InOut,
                    PipeOptions.Asynchronous);

                await stream.ConnectAsync(cancellationToken);

                return stream;
            }
        };

        httpClient = new HttpClient(handler)
        {
            BaseAddress = new Uri("http://localhost")
        };
    }


    public async Task<string> CreateNodeAsync(
        CreateNodeRequest request,
        CancellationToken cancellationToken = default)
    {
        var containerConfig = new
        {
            Image = request.Image,

            Labels = new Dictionary<string, string>
            {
                ["nodemanager.node"] = "true",
                ["nodemanager.name"] = request.Name
            },

            HostConfig = new
            {
                Memory = request.MemoryBytes,
                NanoCpus = request.NanoCpus
            }
        };

        var response = await httpClient.PostAsJsonAsync(
            "/containers/create",
            containerConfig,
            cancellationToken);

        response.EnsureSuccessStatusCode();

        var result =
            await response.Content.ReadFromJsonAsync<NodeResult>(
                cancellationToken);

        if (result is null)
            throw new InvalidOperationException(
                "Docker не вернул информацию о контейнере.");

        await StartContainerAsync(
            result.Id,
            cancellationToken);

        return result.Id;
    }

    private async Task<string> CreateNetworkAsync(
        string networkName,
        CancellationToken cancellationToken = default)
    {
        var networkConfig = new
        {
            Name = networkName,
            Driver = "bridge",
            Labels = new Dictionary<string, string>
            {
                ["nodemanager.network"] = "true"
            }
        };

        var response = await httpClient.PostAsJsonAsync(
            "/networks/create",
            networkConfig,
            cancellationToken);

        var body = await response.Content.ReadAsStringAsync(cancellationToken);

        Console.WriteLine($"Status: {response.StatusCode}");
        Console.WriteLine($"Body: {body}");

        response.EnsureSuccessStatusCode();

        var result = JsonSerializer.Deserialize<NetworkResult>(
            body,
            new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

        if (result is null)
            throw new InvalidOperationException(
                "Docker не вернул информацию о сети.");

        return result.Id;
    }

    public async Task<bool> NetworkExistsAsync(
        string networkName,
        CancellationToken cancellationToken = default)
    {
        var response = await httpClient.GetAsync(
            $"/networks/{Uri.EscapeDataString(networkName)}",
            cancellationToken);

        if (response.IsSuccessStatusCode)
            await EnsureNetworkAsync(networkName, cancellationToken);
        else
            await CreateNetworkAsync(networkName, cancellationToken);

        return response.IsSuccessStatusCode;
    }

    private async Task<string> EnsureNetworkAsync(
        string networkName,
        CancellationToken cancellationToken = default)
    {
        if (await NetworkExistsAsync(networkName, cancellationToken))
        {
            var response = await httpClient.GetAsync(
                $"/networks/{Uri.EscapeDataString(networkName)}",
                cancellationToken);

            response.EnsureSuccessStatusCode();

            var network = await response.Content
                .ReadFromJsonAsync<NetworkResult>(
                    cancellationToken);

            return network?.Id
                   ?? throw new InvalidOperationException(
                       "Не удалось получить ID существующей сети.");
        }

        return await CreateNetworkAsync(
            networkName,
            cancellationToken);
    }

    private async Task StartContainerAsync(
        string containerId,
        CancellationToken cancellationToken)
    {
        var response = await httpClient.PostAsync(
            $"/containers/{containerId}/start",
            null,
            cancellationToken);

        response.EnsureSuccessStatusCode();
    }
}

public class NodeResult
{
    public string Id { get; init; } = string.Empty;
}

public sealed class CreateNodeRequest
{
    public string Name { get; init; } = string.Empty;

    public string Image { get; init; } = string.Empty;

    public long MemoryBytes { get; init; }

    public long NanoCpus { get; init; }
}

public sealed class NetworkResult
{
    public string Id { get; init; } = string.Empty;

    public string Warning { get; init; } = string.Empty;
}