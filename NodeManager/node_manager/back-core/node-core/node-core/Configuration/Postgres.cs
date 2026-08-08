namespace node_core.Configuration;

public class Postgres()
{
    public string username;
    public string password;
    public string database;
    public string host;
    public string port;

    public Postgres GetLocalDb()
    {
        return new Postgres
        {
            username  = "node_manager",
            password = "ytdty13579",
            database = "postgres",
            host = "localhost",
            port = "5432",
        };
    }
}
