# Require redis gem and create new Redis client that points to localhost:6379 by default (on dev)

# TODO: on prod, we need to use Heroku instead of a local Redis server. So `REDIS` below will
# need to be defined differently based on whether we're on dev or prod.

uri = URI.parse(ENV[postgres://fnfgluscuuumbu:72e86abee74de58b6c9355d4060766d937e58cd77f9153639033df8f4d1d9550@ec2-52-3-2-245.compute-1.amazonaws.com:5432/davmj8ci67fa5] || "redis://localhost:6379/" )
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

# REDIS.set("camp_interest", true)
# REDIS.set("exp_interest", false)
# REDIS.set("tech_interest", false)
