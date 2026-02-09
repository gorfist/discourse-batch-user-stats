# Discourse Batch User Stats

A Discourse plugin that provides a batch endpoint for retrieving user follower counts and "following" status for the current user.

## Features

- **Batch Retrieval:** Fetch stats for multiple users in a single request.
- **Optimized SQL:** Uses bulk queries for efficient data retrieval.
- **Following Status:** Checks if the currently logged-in user follows the requested users.

## Installation

1.  Add the plugin's repository URL to your container's `app.yml` file:
    ```yaml
    hooks:
      after_code:
        - exec:
            cd: $home/plugins
            cmd:
              - git clone https://github.com/your-repo/discourse-batch-user-stats.git
    ```
2.  Rebuild your container:
    ```bash
    ./launcher rebuild app
    ```

## Usage

### API Endpoint

**GET** `/u/batch-stats`

### Parameters

- `user_ids`: A comma-separated list of user IDs (e.g., `1,2,3`).

### Example Request

```
GET https://your-forum.com/u/batch-stats?user_ids=1,2,3
```

### Example Response

```json
{
  "users": [
    {
      "user_id": 1,
      "follower_count": 12,
      "is_followed_by_me": true
    },
    {
      "user_id": 2,
      "follower_count": 0,
      "is_followed_by_me": false
    }
  ]
}
```

## Configuration

- `batch_user_stats_enabled`: Enable or disable the plugin (default: `true`).

## License

MIT
