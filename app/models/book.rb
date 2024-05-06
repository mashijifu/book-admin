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

  # validateブロックを使用したバリデーション
  # 以下のバリデーションは、本の名前に「exercise」という文字列が含まれている場合に、バリデーションエラーを発生させる
  validate do |book|
    if book.name.include?("exercise")
      book.errors[:name] << "I don't like exercise."
    end
  end

  # before_validationブロックを使用したバリデーション
  # 以下のバリデーションは、本の名前に「Cat」という文字列が含まれていた場合に、「lovely Cat」という文字列に置き換える
  before_validation do
    self.name = self.name.gsub(/Cat/) do |matched|
      "lovely #{matched}"
    end
  end

  # あるいはメソッドを使用して以下のようにも書ける
  # before_validation :add_lovely_to_cat

  # def add_lovely_to_cat
  #   self.name = self.name.gsub(/Cat/) do |matched|
  #     "lovely #{matched}"
  #   end
  # end

  # after_destroyブロックを使用したコールバック
  # 以下のコールバックは、本が削除された後に、削除された本の名前をログに出力する
  after_destroy do
    Rails.logger.info "Book is deleted: #{self.attributes}"
  end
end
