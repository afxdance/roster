# Require redis gem and create new Redis client that points to localhost:6379 by default (TODO make this different for prod and dev)

require "redis"
REDIS = Redis.new

puts "It would suck to see this twice"

# REDIS.set("camp_interest", true)
# REDIS.set("exp_interest", false)
# REDIS.set("tech_interest", false)
