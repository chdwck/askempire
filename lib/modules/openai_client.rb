require 'uri'
require 'net/http'
require 'json'

module OpenaiClient
  COMPLETION_MODEL_TOKEN_LIMIT = 4096
  COMPLETION_MODEL = "gpt-3.5-turbo"
  COMPLETION_URI = URI("https://api.openai.com/v1/chat/completions")
  EMBEDDING_MODEL = "text-embedding-ada-002"
  EMBEDDING_URI = URI("https://api.openai.com/v1/embeddings")

  private
  def self.make_post_request (uri, data)
    if ENV['OPENAI_API_KEY'] == nil
      raise "Missing OPENAI_API_KEY in .env"
    end

    result = Net::HTTP.post(
      uri, 
      data.to_json, 
      { "Content-Type" => "application/json", "Authorization" => "Bearer " + ENV['OPENAI_API_KEY'] }
    )

    if result.code_type != Net::HTTPOK
      raise "RATE LIMITS!"
    end
    puts result.body
    JSON.parse(result.body)['data']
  end

  def self.get_chat_completion (prompt)
    puts prompt
    prompt_as_messages = [{ "role" => "system", "content": prompt }]
    data = self.make_post_request(COMPLETION_URI, { 
      "model" => COMPLETION_MODEL, 
      "messages" => prompt_as_messages,
      "max_tokens" => COMPLETION_MODEL_TOKEN_LIMIT
    })

    data
  end

  def self.get_embedding (input)
    data = self.make_post_request(EMBEDDING_URI, { "model" => EMBEDDING_MODEL, "input" => input })

    embedding = data[0]['embedding']
    embedding
  end
end
