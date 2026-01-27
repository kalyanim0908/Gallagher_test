using Microsoft.AspNetCore.Mvc.Testing;

namespace AjgPlatformTest.Tests;

public class CalculationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> factory;

    public CalculationTests(WebApplicationFactory<Program> factory)
    {
        this.factory = factory;
    }

    [Theory]
    [InlineData(1, 2, 3)]
    [InlineData(5, 10, 15)]
    [InlineData(-1, 1, 0)]
    [InlineData(0, 0, 0)]
    public async Task Calculate_ReturnsCorrectSum(int a, int b, int expected)
    {
        // Arrange
        var client = this.factory.CreateClient();

        // Act
        var response = await client.GetAsync($"/calculate?a={a}&b={b}");

        // Assert
        response.EnsureSuccessStatusCode();
        var result = await response.Content.ReadAsStringAsync();
        Assert.Equal(expected.ToString(), result);
    }
}
