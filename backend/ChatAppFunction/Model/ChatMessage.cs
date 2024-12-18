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
        [JsonProperty("senderName")]
        [JsonPropertyName("senderName")]
        public string SenderName { get; set; }
        [JsonProperty("senderEmail")]
        [JsonPropertyName("senderEmail")]
        public string SenderEmail{ get; set; }
        [JsonProperty("timestamp")]
        [JsonPropertyName("timestamp")]
        public string Timestamp { get; set; }

    }
}
