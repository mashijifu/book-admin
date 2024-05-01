class Book < ApplicationRecord
  # nilを返す必要がある場合は、scopeではなくクラスメソッドを使う
  scope :costly, -> { where("price > ?", 3000) }
  scope :written_about, ->(theme) { where("name like ?", "%#{theme}%") }
end
