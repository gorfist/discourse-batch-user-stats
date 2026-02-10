# name: discourse-batch-user-stats
# about: Provides a batch endpoint for user follow statistics
# version: 0.3
# authors: Arzdigital
# url: https://github.com/your-repo/discourse-batch-user-stats

enabled_site_setting :batch_user_stats_enabled

require_relative "lib/batch_user_stats/engine"

after_initialize do
  # No need for manual load since we're using an Engine
end
