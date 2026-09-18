using API.Application.DTO;
using API.Infrastructure.Helpers;
using API.Infrastructure.Services.Auth;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Web.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AuthController : ControllerBase
{
    private readonly AuthService _authService;

    public AuthController(AuthService authService)
    {
        _authService = authService;
    }

    [HttpPost("login")]
    public IActionResult Login([FromBody] LoginDTO loginReq)
    {
        try
        {
            var token = _authService.Login(loginReq);

            switch (token.LoginResult)
            {
                case LoginResult.NotFound:
                {
                    Logger.Warn($"Попытались авторизироваться на {loginReq.Email}, но таких незнаем");
                    return NotFound();
                }
                case LoginResult.InvalidPassword:
                {
                    Logger.Warn($"Попытались авторизироваться на {loginReq.Email}, а пароль-то неверный, проверЬ!");
                    return StatusCode(403);
                }
                case LoginResult.Unknown:
                    return StatusCode(500);
                case LoginResult.Success:
                    return Ok(token);
                default:
                    return StatusCode(500);
            }
        }
        catch (Exception ex)
        {
            Logger.Error("Упс... А не получилось авторизоваться", ex);
            return StatusCode(500, ex.Message);
        }
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterDTO registerDTO)
    {
        try
        {
            var result = await _authService.Register(registerDTO);
            if (result == RegisterResult.AlreadyExists)
            {
                Logger.Warn($"Такая запись уже есть");
                return BadRequest();
            }
            return Ok(result);
        }
        catch (DbUpdateException ex)
        {
            Logger.Error("Упс... А не зарегистрироваться не получилось", ex);
            return StatusCode(500, ex.Message);
        }
    }
}