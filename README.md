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

**GET** `/batch-user-stats`

### Authentication

This endpoint supports **Discourse API authentication** using the standard headers:

| Header | Description |
|--------|-------------|
| `Api-Key` | Your Discourse API key (generated in Admin > API > Keys) |
| `Api-Username` | The username to act as (determines `is_followed_by_me` values) |

> **Note:** If no authentication is provided, the endpoint still works but `is_followed_by_me` will always be `false`.

### Parameters

- `user_ids`: A comma-separated list of user IDs (e.g., `1,2,3`). Maximum 50 IDs per request.

### Example Request (with API Authentication)

```bash
curl -X GET "https://your-forum.com/batch-user-stats?user_ids=1,2,3" \
  -H "Api-Key: your_api_key_here" \
  -H "Api-Username: requesting_username"
```

### Example Request (Anonymous)

```
GET https://your-forum.com/batch-user-stats?user_ids=1,2,3
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
