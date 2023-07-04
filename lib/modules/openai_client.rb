require 'uri'
require 'net/http'
require 'json'

module OpenaiClient
  EMBEDDING_MODEL = "text-embedding-ada-002"
  BASE_URI = URI("https://api.openai.com/v1/embeddings")

  def self.get_embedding (input)
    if ENV['OPENAI_API_KEY'] == nil
      raise "Missing OPENAI_API_KEY in .env"
    end

    result = Net::HTTP.post(
      BASE_URI, 
      { "model" => EMBEDDING_MODEL, "input" => input }.to_json, 
      { "Content-Type" => "application/json", "Authorization" => "Bearer " + ENV['OPENAI_API_KEY'] }
    )
    
    if result.code_type != Net::HTTPOK
      raise "RATE LIMITS!"
    end

    embedding = JSON.parse(result.body)['data'][0]['embedding']
    return embedding
  end
end
