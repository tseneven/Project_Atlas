using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Infrastructure.Entities;

[Table("brokerage_account")]
public class BrokerageAccount : IEntity
{
    [Key] 
    [Column("id")] public int Id { get; set; }
    [MaxLength(10)]
    [Column("account_number")] public required string AccountNumber { get; set; }
    [Column("account_type")] public AccountType AccountType { get; set; }
    [Column("access_level")] public AccessLevel AccessLevel { get; set; }
    [Column("opened_date")] public DateTime OpenedDate { get; set; }
    [Column("closed_date")] public DateTime ClosedDate { get; set; }

    public User User { get; set; } = null!;
    public ICollection<Assets> Assets { get; set; } = [];
}

public enum AccountType
{
    None = 0,
    Brokerage = 1,
    Iis = 2,
}

public enum AccessLevel
{
    None = 0,
    FullAccess = 1,
    ReadOnly = 2,
    NoAccess = 3,
}