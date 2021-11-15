# Require redis gem and create new Redis client that points to localhost:6379 by default (TODO make this different for prod and dev)

$redis = Redis.new(url: ENV["REDIS_URL"], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })

require "redis"
REDIS = Redis.new

# REDIS.set("camp_interest", true)
# REDIS.set("exp_interest", false)
# REDIS.set("tech_interest", false)
