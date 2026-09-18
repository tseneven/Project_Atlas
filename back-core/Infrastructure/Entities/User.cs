using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Infrastructure.Entities
{
    [Table("Users")]
    public class User : IEntity
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(30)]
        public string Login { get; set; }

        [Required]
        [MaxLength(50)]
        public string Email { get; set; }

        [Required]
        [MaxLength(100)]
        public string HashPassword { get; set; }

        [Required]
        [MaxLength(100)]
        public string Salt { get; set; }
    }
}
