BatchUserStats::Engine.routes.draw do
  get "/u/batch-stats" => "batch_user_stats#show"
end
