class Book < ApplicationRecord
  # nilを返す必要がある場合は、scopeではなくクラスメソッドを使う
  scope :costly, -> { where("price > ?", 3000) }
  scope :written_about, ->(theme) { where("name like ?", "%#{theme}%") }

  belongs_to :publisher
  has_many :book_authors
  has_many :authors, through: :book_authors

  # railsコンドールでバリデーションエラーを確認する方法
  # errorsメソッドを使う(例：book.errors)
  # full_messagesメソッドを使う（例：book.errors.full_messages）
  # 保存をせずにバリデーションを確認する方法
  # valid?メソッドを使う（例：book.valid?）バリデーションをすべて通過すればtrue、どこかで失敗すればfalseを返す
  # ActiveRecordの!有無の違い
  # 「!」を伴なわないメソッドはバリデーション失敗時に例外を起こさない
  # 「!」を伴なうメソッドはバリデーション失敗時には例外「ActiveRecord::RecordInvalid」が起こる

  # 以下のバリデーションは、nameが空でないこと、nameが25文字以内であること、priceが0以上であることを確認する
  validates :name, presence: true
  validates :name, length: { maximum: 25 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
