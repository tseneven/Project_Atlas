using API.Infrastructure.Entities;
using Microsoft.EntityFrameworkCore;

namespace API.Infrastructure.Migration
{
    public class ApplicationContext(DbContextOptions<ApplicationContext> options) : DbContext(options)
    {
        public DbSet<User> Users { get; set; }
        
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();
            
            modelBuilder.Entity<BrokerageAccount>()
                .HasOne(x => x.User)
                .WithMany(x => x.BrokerageAccounts)
                .HasForeignKey(x => x.User.Id);
            
            base.OnModelCreating(modelBuilder);
        }
    }

}