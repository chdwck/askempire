require 'csv'

module Answers
  class Answerer
    PROMPT_PREFIX = "Answer the given question using the given context pages. If the given context allows for it, " +
      "respond as if you are Gabriel DeLeon, the first person narrator in the story. Otherwise explain your answer as you would " +
      "a historical event. Limit answers to a maximum of 500 words. question: ";
    PROMPT_PREFIX_TOKEN_LEN = 61  
    
    RelevantPage = Struct::new(:page, :text, :tokens, :cosine_similarity)
    
    def initialize(question_text)
      @question_text = question_text
      @book_table = CSV.parse(File.read("book.data.csv"), headers: true).by_row!
    end

    def get_answer()
      embedding = OpenaiClient.get_embedding(@question_text)
      relevance_desc = @book_table.map do |row|
        saved_embedding = row['psv_embedding'].split('|').map(&:to_f)
        cosine_similarity = self.cosine_similarity(embedding, saved_embedding)
        RelevantPage.new(row['page'], row['text'], row['tokens'].to_f, cosine_similarity)
      end
    
      relevance_desc.sort! { |a, b| b.cosine_similarity <=> a.cosine_similarity  }
      
      i = 0
      tokens_included = PROMPT_PREFIX_TOKEN_LEN
      context = ""
      while tokens_included < OpenaiClient::COMPLETION_MODEL_TOKEN_LIMIT && i < relevance_desc.length
        relevant_page = relevance_desc[i]
        next_tokens_count = relevant_page.tokens + tokens_included
        if next_tokens_count >= OpenaiClient::COMPLETION_MODEL_TOKEN_LIMIT
          break
        end
        context = context + relevance_desc[i].text + '\n'
        tokens_included = next_tokens_count
        i = i + 1
      end
      
      full_prompt =  PROMPT_PREFIX + @question_text + "\n" +
        "context: " + context 
      completion_data = OpenaiClient::get_chat_completion(full_prompt) 
      completion_data
    end

    def cosine_similarity(vector, vector2)
      dot_product = 0
      i = 0
      while i < vector.length and i < vector2.length
        dot_product = dot_product + (vector[i] * vector2[i])
        i = i + 1
      end

      magnitude1 = Math.sqrt(vector.reduce(0) { |sum, num| sum + (num * num) }) 
      magnitude2 = Math.sqrt(vector2.reduce(0) { |sum, num| sum + (num * num) })

      return dot_product / (magnitude1 * magnitude2)
    end
  end
end
