module RedisUtility
  def self.store_data(var, value)
    $redis.set(var, value)
  end

  def self.fetch_data(var)
    $redis.get(var)
  end
end
