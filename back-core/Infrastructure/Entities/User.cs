using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Infrastructure.Entities
{
    [Table("users")]
    public class User : IEntity
    {
        [Key]
        [Column("user_id")]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("email")]
        public string Email { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("hash_password")]
        public string HashPassword { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("salt")]
        public string Salt { get; set; }
    }
}
