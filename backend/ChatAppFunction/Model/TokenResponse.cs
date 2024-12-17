using Newtonsoft.Json;
using System.Text.Json.Serialization;

namespace ChatAppFunction.Model
{
    public class TokenResponse
    {
        [JsonProperty("url")]
        [JsonPropertyName("url")]
        public string Url { get; set; }
    }
}
