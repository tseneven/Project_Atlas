using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using API.Infrastructure.Helpers;

namespace API.Application.Services.TBankIntegation;

public class TBankIntegationService(EntityStorage entityStorage, HttpClient httpClient)
{
    public async Task<string> GetPortfolio(string token, string accountId)
    {
        using var request = new HttpRequestMessage(
            HttpMethod.Post,
            "https://invest-public-api.tinkoff.ru/rest/tinkoff.public.invest.api.contract.v1.OperationsService/GetPortfolio"
        );

        request.Headers.Authorization =
            new AuthenticationHeaderValue("Bearer", token);

        var json = JsonSerializer.Serialize(new
        {
            account_id = accountId,
        });

        request.Content = new StringContent(json,
            Encoding.UTF8,
            "application/json");

        var response = await httpClient.SendAsync(request);
        response.EnsureSuccessStatusCode();
        
        var responseJson = await response.Content.ReadAsStringAsync();

        var positions = JsonSerializer.Deserialize<PortfolioResponseDto>(responseJson);
        
        return responseJson;
    }
}

public class PortfolioResponseDto
{
    [JsonPropertyName("positions")]
    public List<PortfolioPositionDto> Positions { get; set; } = [];
}

public class PortfolioPositionDto
{
    [JsonPropertyName("ticker")]
    public string? Tiker { get; set; }

    [JsonPropertyName("figi")]
    public string? Figi { get; set; }

    [JsonPropertyName("averagePositionPrice")]
    public MoneyValue? AveragePositionPrice { get; set; }

    [JsonPropertyName("quantityLots")]
    public string? QuantityLots { get; set; }
}

public class MoneyValue
{
    [JsonPropertyName("units")]
    public string? Units { get; set; }

    [JsonPropertyName("nano")]
    public int Nano { get; set; }

    public decimal ToDecimal()
    {
        return decimal.Parse(Units ?? "0")
               + Nano / 1_000_000_000m;
    }
}