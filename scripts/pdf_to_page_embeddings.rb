require 'dotenv/load'
require 'pdf-reader'
require 'tiktoken_ruby'
require 'csv'

require_relative '../lib/modules/openai_client.rb'

CSV_HEADERS = ['page', 'tokens', 'text', 'psv_embedding']

book_path = ARGV[0];
reader = PDF::Reader.new(book_path)

puts reader.pdf_version
puts reader.info
puts reader.page_count

enc = Tiktoken.get_encoding("cl100k_base")
CSV.open("book.data.csv", "w") do |csv|
  csv << CSV_HEADERS
  page_num = 0
  while page_num < reader.pages.length
    page_text = reader.pages[page_num].text
    page_token_len = enc.encode(page_text).length
    embedding = OpenaiClient.get_embedding(page_text)
    embedding_psv = embedding.join("|")
    csv << [page_num + 1, page_token_len, page_text, embedding_psv]
    page_num = page_num + 1
  end
end

