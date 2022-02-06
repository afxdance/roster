# Require redis gem and create new Redis client that points to localhost:6379 by default (on dev)

# TODO: on prod, we need to use Heroku instead of a local Redis server. So `REDIS` below will
# need to be defined differently based on whether we're on dev or prod.

require "redis"
REDIS = Redis.new

# REDIS.set("camp_interest", true)
# REDIS.set("exp_interest", false)
# REDIS.set("tech_interest", false)
