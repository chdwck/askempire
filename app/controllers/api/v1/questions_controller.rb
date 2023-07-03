class Api::V1::QuestionsController < ApplicationController
  # POST /questions
  # POST /questions.json
  def create
    answer = "test"
    context = "test"
    ask_count = 1
    puts :question
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
