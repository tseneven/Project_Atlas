using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Infrastructure.Entities;

public class Assets : IEntity
{
    [Key]
    [Column("id")]
    public int Id { get; set; }
    [MaxLength(4)]
    [Column("tiker")]
    public required string Tiker { get; set; }
    [MaxLength(12)]
    [Column("figi")]
    public required string Figi { get; set; }
    [Column("average_position_price")]
    public decimal AveragePositionPrice { get; set; }
    [Column("quantity_lots")]
    public int QuantityLots { get; set; }
    
    public BrokerageAccount BrokerageAccount { get; set; } = null!;
}