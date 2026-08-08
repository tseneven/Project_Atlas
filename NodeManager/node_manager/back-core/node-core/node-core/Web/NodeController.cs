using Microsoft.AspNetCore.Mvc;
using node_core.Services;

namespace node_core.Web;

[Route("api/node")]
public class NodeController(DockerService dockerService) : ControllerBase
{
    [HttpPost("createNode")]
    public async Task<IActionResult> CreateNode(
        [FromBody] NodeParametrs nodeParametrs)
    {
        try
        {
            var resultCreateImage = dockerService.CreateNodeImageAsync("ubuntu").GetAwaiter().GetResult();

            if (resultCreateImage.Contains("OK"))
            {
                await dockerService.CreateNodeAsync(new CreateNodeRequest
                {
                    Name = nodeParametrs.Name,
                    Image = nodeParametrs.Image,
                    MemoryBytes = nodeParametrs.MemoryBytes,
                    NanoCpus = nodeParametrs.NanoCpus,
                });
            }
            else
                throw new InvalidOperationException(
                    "Node creation failed, не смогли создать image");
            
            return Ok();
        }
        catch (Exception e)
        {
            throw new InvalidOperationException(
                "Node creation failed", e);
        }
    }
    
    [HttpPost("createNetwork")]
    public async Task<IActionResult> CreateNetwork()
    {
        try
        {
            await dockerService.EnsureNetworkAsync("nodeNetwork");

            return Ok();
        }
        catch (Exception e)
        {
            throw new InvalidOperationException(
                "Node creation failed", e);
        }
    }
    
    [HttpGet("getAllNodes")]
    public async Task<List<DockerContainer>?> GetAllNodes()
    {
        try
        {
            return await dockerService.GetAllNodes();
        }
        catch (Exception e)
        {
            throw new InvalidOperationException(
                "Node creation failed", e);
        }
    }
    
    [HttpGet("test")]
    public async Task<IActionResult> Test()
    {
        // await dockerService.ImageExistsAsync();
        return Ok();
    }
}

public class NodeParametrs()
{
    public string Name { get; init; } = string.Empty;

    public string Image { get; init; } = string.Empty;

    public long MemoryBytes { get; init; }

    public long NanoCpus { get; init; }
}

public sealed class CreateNodeRequest
{
    public string Name { get; init; } = string.Empty;

    public string Image { get; init; } = string.Empty;

    public long MemoryBytes { get; init; }

    public long NanoCpus { get; init; }
}