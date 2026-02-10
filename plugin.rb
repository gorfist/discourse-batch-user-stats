# name: discourse-batch-user-stats
# about: Provides a batch endpoint for user follow statistics
# version: 0.2
# authors: Arzdigital
# url: https://github.com/your-repo/discourse-batch-user-stats

enabled_site_setting :batch_user_stats_enabled

after_initialize do
  # Load the controller
  load File.expand_path("../app/controllers/batch_user_stats_controller.rb", __FILE__)

  Discourse::Application.routes.prepend do
    get "/u/batch-stats" => "batch_user_stats#show", constraints: { format: :json }
  end
end
