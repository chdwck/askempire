class QuestionsController < ApplicationController
  def details
    @question = Question.find(params[:id])
  end
end
