using API.Application.DTO;

namespace API.Infrastructure.Repositorys.Auth;

public interface IAuth_Repository
{
    Task<string> Register(RegisterDTO registerDTO);
    Task<AuthDTO> Login(RegisterDTO registerDTO);
}