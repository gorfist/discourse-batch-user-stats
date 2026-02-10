# frozen_string_literal: true

BatchUserStats::Engine.routes.draw do
  get "/" => "batch_user_stats#show",
      :constraints => {
        format: /(json|html)/,
      },
      :defaults => {
        format: :json,
      }
end

Discourse::Application.routes.draw do
  mount ::BatchUserStats::Engine, at: "/u/batch-stats"
end
