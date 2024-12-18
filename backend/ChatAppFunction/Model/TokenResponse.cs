using Newtonsoft.Json;
using System.Text.Json.Serialization;

namespace ChatAppFunction.Model
{
    public class TokenResponse
    {
        [JsonProperty("accessToken")]
        [JsonPropertyName("accessToken")]
        public string AccessToken { get; set; }
    }
}
