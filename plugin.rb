# name: discourse-batch-user-stats
# about: Provides a batch endpoint for user follow statistics
# version: 0.1
# authors: Arzdigital
# url: https://github.com/your-repo/discourse-batch-user-stats

enabled_site_setting :batch_user_stats_enabled

after_initialize do
  module ::BatchUserStats
    class Engine < ::Rails::Engine
      engine_name "batch_user_stats"
      isolate_namespace BatchUserStats
    end
  end

  require_dependency File.expand_path("../app/controllers/batch_user_stats/batch_user_stats_controller.rb", __FILE__)
  
  # Load routes for the engine
  BatchUserStats::Engine.routes.draw do
    get "/u/batch-stats" => "batch_user_stats#show"
  end

  Discourse::Application.routes.prepend do
    mount ::BatchUserStats::Engine, at: "/"
  end
end
