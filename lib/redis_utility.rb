module RedisUtility
  def self.store_data(var, value)
    $redis.set(var, value)
  end

  def self.fetch_data(var)
    $redis.get(var)
  end

  def self.append_count(var, value)
    current_count = fetch_data(var)
    if current_count.to_i.positive?
      store_data(var, current_count.to_i + value.to_i)
    else
      store_data(var, value.to_i)
    end
  end

  def self.reset_count(var)
    store_data(var, 0)
  end
end
