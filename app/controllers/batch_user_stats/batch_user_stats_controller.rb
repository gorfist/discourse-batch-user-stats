# frozen_string_literal: true

class BatchUserStats::BatchUserStatsController < ::ApplicationController
  requires_plugin "discourse-batch-user-stats"

  skip_before_action :verify_authenticity_token, only: [:show]

  def show
    # Robust parsing of user_ids from comma-separated string or array
    if params[:user_ids].is_a?(String)
      ids = params[:user_ids].split(",")
    else
      ids = params[:user_ids] || []
    end

    user_ids = ids.map(&:to_i).uniq.reject(&:zero?).first(50)

    if user_ids.blank?
      return render json: { error: "No user IDs provided" }, status: 400
    end

    # Safe SQL interpolation for the IN clause since we've cast everything to integers
    ids_sql = user_ids.join(",")

    # 1. Get Follower Counts (Bulk Query)
    sql_counts = <<~SQL
      SELECT user_id, COUNT(*) as count 
      FROM user_followers 
      WHERE user_id IN (#{ids_sql}) 
      GROUP BY user_id
    SQL

    follower_counts = {}
    DB.query(sql_counts).each do |r|
      follower_counts[r.user_id.to_i] = r.count.to_i
    end

    # 2. Check if current user follows these users (Bulk Query)
    following_map = {}
    if current_user
      sql_following = <<~SQL
        SELECT user_id 
        FROM user_followers 
        WHERE follower_id = :current_user_id 
        AND user_id IN (#{ids_sql})
      SQL

      DB.query(sql_following, current_user_id: current_user.id).each do |r|
        following_map[r.user_id.to_i] = true
      end
    end

    # 3. Construct response
    result = user_ids.map do |id|
      {
        user_id: id,
        follower_count: follower_counts[id] || 0,
        is_followed_by_me: following_map[id] || false,
      }
    end

    render json: { users: result }
  end
end
