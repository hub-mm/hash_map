# hash_map.rb
# frozen_string_literal: true

class HashMap
  LOAD_FACTOR = 0.75

  def initialize(size = 16)
    @size = size
    @buckets = Array.new(@size) { [] }
    @count = 0
  end

  def hash(key)
    key.hash % @size
  end

  def set(key, value)
    index = hash(key)
    bucket = @buckets[index]

    pair = bucket.find { |k, _v| k == key }

    if pair
      pair[1] = value
    else
      bucket << [key, value]
      @count += 1
    end

    return unless load_factor_exceeded?

    resize
  end

  def get(key)
    index = hash(key)
    bucket = @buckets[index]

    pair = bucket.find { |k, _v| k == key }
    pair ? pair[1] : nil
  end

  def delete(key)
    index = hash(key)
    bucket = @buckets[index]

    return unless bucket.reject! { |k, _v| k == key }

    @count -= 1
  end

  def contains?(key)
    !get(key).nil?
  end

  def length
    @count
  end

  def clear
    @buckets = Array.new(@size) { [] }
    @count = 0
  end

  def values
    all_values = []
    @buckets.each do |bucket|
      bucket.each do |pair|
        all_values << pair[1]
      end
    end
    all_values
  end

  def entries
    all_entries = []
    @buckets.each do |bucket|
      bucket.each do |pair|
        all_entries << pair
      end
    end
    all_entries
  end

  def load_factor_exceeded?
    current_load_factor = @count.to_f / @size
    puts "Current load factor: #{current_load_factor.round(2)}"
    current_load_factor > LOAD_FACTOR
  end

  def resize
    new_size = @size * 2
    new_buckets = Array.new(new_size) { [] }

    @buckets.each do |bucket|
      bucket.each do |key, value|
        new_index = key.hash % new_size
        new_buckets[new_index] << [key, value]
      end
    end

    @buckets = new_buckets
    @size = new_size
  end
end
