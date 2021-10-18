# Require redis gem and create new Redis client that points to localhost:6379 by default (TODO make this different for prod and dev)

require "redis"
REDIS = Redis.new
