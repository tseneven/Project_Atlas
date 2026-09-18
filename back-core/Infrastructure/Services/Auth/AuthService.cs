using API.Application.DTO;
using API.Domain;
using API.Infrastructure.Entities;
using API.Infrastructure.Helpers;
using API.Infrastructure.Services.Auth.Guards;

namespace API.Infrastructure.Services.Auth
{
    public class AuthService(JwtService jwtService, EntityStorage entityStorage)
    {


        public async Task<RegisterResult> Register(RegisterDTO registerDTO)
        {
            var result = entityStorage.Select<User>().FirstOrDefault(u => u.Email == registerDTO.Email);

            if (result == null)
            {
                var salt = PasswordHelper.GenerateSalt();
                var saltString = Convert.ToBase64String(salt);
                var hashPassword = PasswordHelper.HashPassword(registerDTO.Password, salt);
                var hashPasswordString = Convert.ToBase64String(hashPassword);
                User userDTO = new User()
                {
                    Email = registerDTO.Email,
                    Salt = saltString,
                    HashPassword = hashPasswordString,
                    Login = registerDTO.Username,
                };

                await entityStorage.CreateAsync(userDTO);
                return RegisterResult.Success;
            }

            return RegisterResult.AlreadyExists;
        }

        public AuthDTO Login(LoginDTO loginReq)
        {
            try
            {
                var userEntity = entityStorage.Select<User>().FirstOrDefault(u => u.Email == loginReq.Email);

                if (userEntity == null)
                    return new AuthDTO { LoginResult = LoginResult.NotFound };

                var userDTO = new UserDTO
                {
                    Id = userEntity.Id,
                    Login = userEntity.Login,
                    Email = userEntity.Email,
                    PasswordHash = userEntity.HashPassword,
                    Salt = userEntity.Salt,
                };

                var saltBytes = Convert.FromBase64String(userDTO.Salt);
                var hashPassword = PasswordHelper.HashPassword(loginReq.Password, saltBytes);
                var hashPasswordString = Convert.ToBase64String(hashPassword);

                if (userDTO.PasswordHash == hashPasswordString)
                {
                    var token = jwtService.GenerateToken(userDTO.Id.ToString(), userDTO.Email);
                    return new AuthDTO
                        { Token = token, UserId = userEntity.Id.ToString(), Username = userEntity.Login, LoginResult = LoginResult.Success};
                }

                return new AuthDTO { LoginResult = LoginResult.InvalidPassword };
            }
            catch(Exception ex)
            {
                Logger.Error($"{loginReq.Email}: Что-то упало...",ex);
                return new AuthDTO { LoginResult = LoginResult.Unknown };
            }
        }
    }
    public class AuthDTO
    {
        public String? UserId { get; set; }
        public string? Username { get; set; }
        public string? Token { get; set; }
        public LoginResult LoginResult { get; set; }
    }

    public enum RegisterResult
    {
        Success = 1,
        AlreadyExists = 2,
    }
    
    public enum LoginResult
    {
        Unknown = 1,
        Success = 2,
        NotFound = 3,
        InvalidPassword = 5,
    }
}