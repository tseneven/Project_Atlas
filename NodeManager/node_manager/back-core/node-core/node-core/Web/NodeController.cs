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
            await dockerService.CreateNodeAsync(new CreateNodeRequest
            {
                Name = nodeParametrs.Name,
                Image = nodeParametrs.Image,
                MemoryBytes = nodeParametrs.MemoryBytes,
                NanoCpus = nodeParametrs.NanoCpus,
            });

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
            await dockerService.NetworkExistsAsync("nodeNetwork");

            return Ok();
        }
        catch (Exception e)
        {
            throw new InvalidOperationException(
                "Node creation failed", e);
        }
    }
}

public class NodeParametrs()
{
    public string Name { get; init; } = string.Empty;

    public string Image { get; init; } = string.Empty;

    public long MemoryBytes { get; init; }

    public long NanoCpus { get; init; }
}