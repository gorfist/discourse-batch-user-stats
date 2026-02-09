class BatchUserStats::BatchUserStatsController < ::ApplicationController
  # Skip CSRF verification for API requests (using Api-Key + Api-Username headers)
  skip_before_action :verify_authenticity_token, only: [:show]
  
  # Allow anonymous access - is_followed_by_me will be false for anonymous users
  # current_user is automatically set by Discourse when Api-Key + Api-Username headers are provided
  # If you want to require authentication, uncomment the line below:
  # before_action :ensure_logged_in

  def show
    # 1. Parse and sanitize IDs
    user_ids = params[:user_ids].to_s.split(',').map(&:to_i).uniq.reject(&:zero?).first(50)

    if user_ids.blank?
      return render_json_error("No user IDs provided", status: 400)
    end

    # 2. Get Follower Counts (Bulk Query)
    # Using the table name from the discourse-follow plugin
    follower_counts = DB.query(<<~SQL, user_ids).to_h { |r| [r.user_id, r.count] }
      SELECT user_id, COUNT(*) as count 
      FROM user_followers 
      WHERE user_id IN (?) 
      GROUP BY user_id
    SQL

    # 3. Check if current user follows these users (Bulk Query)
    following_map = {}
    if current_user
      following_map = DB.query(<<~SQL, current_user.id, user_ids).to_h { |r| [r.user_id, true] }
        SELECT user_id 
        FROM user_followers 
        WHERE follower_id = ? AND user_id IN (?)
      SQL
    end

    # 4. Construct response
    result = user_ids.map do |id|
      {
        user_id: id,
        follower_count: follower_counts[id] || 0,
        is_followed_by_me: following_map[id] || false
      }
    end

    render_json_dump({ users: result })
  end
end
