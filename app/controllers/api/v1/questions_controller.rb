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

    puts "QUESTION:"
    puts @existing_question
    
    if @existing_question != nil
      @existing_question.update(ask_count: @existing_question.ask_count + 1)
      render json: @existing_question, status: :ok
      return
    end
    
    puts "HERE"
    answer = "test"
    context = "test"
    ask_count = 1

    @question = Question.new(
      question: params[:question], 
      answer: answer, 
      context: context, 
      ask_count: ask_count
    );

    if @question.save
      render json: @question, status: :created
    else
      render json @question.errors
    end
  end
end
