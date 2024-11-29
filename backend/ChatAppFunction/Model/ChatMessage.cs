using Newtonsoft.Json;
using System.Text.Json.Serialization;

namespace ChatAppFunction.Model
{
    public class ChatMessage
    {
        [JsonProperty("id")]
        [JsonPropertyName("id")]
        public string Id { get; set; }
        [JsonProperty("content")]
        [JsonPropertyName("content")]
        public string Content { get; set; }
        [JsonProperty("senderId")]
        [JsonPropertyName("senderId")]
        public string SenderId { get; set; }
        [JsonProperty("timestamp")]
        [JsonPropertyName("timestamp")]
        public string Timestamp { get; set; }

    }
}
