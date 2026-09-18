using API.Infrastructure.Entities;
using API.Infrastructure.Migration;

namespace API.Infrastructure.Helpers;

public class EntityStorage(ApplicationContext context)
{
    public IQueryable<T> Select<T>() where T : class
    {
        return context.Set<T>();
    }

    public async Task<int> CreateAsync<T>(T entity) where T : class, IEntity
    {
        try
        {        
            context.Set<T>().Add(entity);
            await context.SaveChangesAsync();

            return entity.Id;
        }
        catch (Exception e)
        {
            Logger.Error("Что-то сломалось при создании записи в Postgres", e);
            throw;
        }
    }
    
    public async void CreateEntityAsync<T>(T entity) where T : class
    {
        try
        {
            var newEntity = entity;
            context.Set<T>().Add(newEntity);
            await Commit();
        }
        catch (Exception e)
        {
            Logger.Error("Что-то сломалось при создании записи в Postgres", e);
        }
    }
    
    
    private Task Commit() => context.SaveChangesAsync();
}