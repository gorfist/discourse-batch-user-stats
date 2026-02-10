# frozen_string_literal: true

module ::BatchUserStats
  class Engine < ::Rails::Engine
    engine_name "batch_user_stats"
    isolate_namespace BatchUserStats
  end
end
