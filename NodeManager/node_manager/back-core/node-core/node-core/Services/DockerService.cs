using System.IO.Pipes;
using System.Text.Json;
using node_core.Web;


namespace node_core.Services;

public class DockerService
{
    private readonly HttpClient _httpClient;

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

        _httpClient = new HttpClient(handler)
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
            Hostnamae = request.Image,
            Domainname = request.Image,
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

        var response = await _httpClient.PostAsJsonAsync(
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

        var response = await _httpClient.PostAsJsonAsync(
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

    private async Task<bool> NetworkExistsAsync(
        string networkName,
        CancellationToken cancellationToken = default)
    {
        var response = await _httpClient.GetAsync(
            $"/networks/{Uri.EscapeDataString(networkName)}",
            cancellationToken);

        if (response.IsSuccessStatusCode)
            await EnsureNetworkAsync(networkName, cancellationToken);
        else
            await CreateNetworkAsync(networkName, cancellationToken);

        return response.IsSuccessStatusCode;
    }

    public async Task<string> EnsureNetworkAsync(
        string networkName,
        CancellationToken cancellationToken = default)
    {
        if (await NetworkExistsAsync(networkName, cancellationToken))
        {
            var response = await _httpClient.GetAsync(
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

    public async Task<string> CreateNodeImageAsync(
        string name,
        CancellationToken cancellationToken = default)
    {
        if (!ImageExistsAsync(name, cancellationToken).GetAwaiter().GetResult())
        {
            var response = await _httpClient.PostAsync(
                $"/images/create?fromImage={name}&tag=latest",
                content: null,
                cancellationToken);
            response.EnsureSuccessStatusCode();


            return response.StatusCode.ToString();
        }
        return "OK. Image уже есть";
    }

    public async Task<bool> ImageExistsAsync(string name, CancellationToken cancellationToken = default)
    {
        var images = await _httpClient.GetFromJsonAsync<List<DockerImage>>(
            "/images/json",
            cancellationToken);

        return images?.Any(x => x.RepoTags.Any(xx => xx.Contains(name))) == true;
    }
    
    public async Task<List<DockerContainer>?> GetAllNodes(CancellationToken cancellationToken = default)
    {
        var containers = await _httpClient.GetFromJsonAsync<List<DockerContainer>>(
            "/containers/json?all=true",
            cancellationToken);

        return containers;
    }

    private async Task StartContainerAsync(
        string containerId,
        CancellationToken cancellationToken)
    {
        var response = await _httpClient.PostAsync(
            $"/containers/{containerId}/start",
            null,
            cancellationToken);

        response.EnsureSuccessStatusCode();
    }
}

public class DockerImage
{
    public string Id { get; set; } = string.Empty;
    public List<string> RepoTags { get; set; } = [];
    public List<string> RepoDigests { get; set; } = [];
    public long Created { get; set; }
    public long Size { get; set; }
}

public class DockerContainer
{
    public string Id { get; set; } = string.Empty;
    public List<string> Names { get; set; } = [];
    public string? Image { get; set; }
    public string? ImageID { get; set; }
    public string? State { get; set; }
    public string? Status { get; set; }
}

public class NodeResult
{
    public string Id { get; init; } = string.Empty;
}

public sealed class NetworkResult
{
    public string Id { get; init; } = string.Empty;
    public string Warning { get; init; } = string.Empty;
}