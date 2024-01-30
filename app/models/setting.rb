class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  def self.get(key)
    setting = find_by(key: key)
    setting.value if setting
  end

  def self.set(key, value)
    setting = find_or_initialize_by(key: key)
    setting.update(value: value)
  end
end
