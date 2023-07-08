
class Api::V1::QuestionsController < ApplicationController
  # POST /questions
  # POST /questions.json
  def create
    question_text = params[:question]

    question_text_sanitized = question_text.gsub(/[\n\t\r]/, "")
    if !question_text_sanitized.ends_with?("?")
      question_text_sanitized += "?"
    end

    @existing_question = Question.where(question: question_text_sanitized).first

    if @existing_question != nil
      @existing_question.update(ask_count: @existing_question.ask_count + 1)
      render json: @existing_question, status: :ok
      return
    end
    
    answer = "test"
    context = "test"

    answerer = Answers::Answerer.new(question_text_sanitized)

    @question = Question.new(
      question: params[:question], 
      answer: answer, 
      context: context, 
      ask_count: 1 
    );

    if @question.save
      render json: @question, status: :created
    else
      render json @question.errors
    end
  end
end
