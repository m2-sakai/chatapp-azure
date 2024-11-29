using Newtonsoft.Json;
using System.Text.Json.Serialization;

namespace ChatAppFunction.Model
{
    public class UserInfo
    {
        [JsonProperty("id")]
        [JsonPropertyName("id")]
        public string Id { get; set; }
        [JsonProperty("name")]
        [JsonPropertyName("name")]
        public string Name { get; set; }
        [JsonProperty("email")]
        [JsonPropertyName("email")]
        public string Email { get; set; }
    }
}
