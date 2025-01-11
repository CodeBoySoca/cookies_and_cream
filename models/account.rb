class Account < ActiveRecord::Base

  def create_account()
  end

  def deactivate_account()
  end

  def cache_account(redis, id, data)
    rc_key = "user:#{id}"
    redis.hset(rc_key, data)
    redis.expire(rc_key, 3600)
  end

  def get_cached_data(redis, id)
    redis.hgetall("user:#{id}")
  end

end
