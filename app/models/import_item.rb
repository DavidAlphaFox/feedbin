class ImportItem < ApplicationRecord
  serialize :details, Hash
  belongs_to :import

  after_commit :import_feed, on: :create

  enum status: [:pending, :complete, :failed]
  store :error, accessors: [:class, :message], coder: JSON, prefix: true

  def import_feed
    FeedImporter.perform_async(id)
  end
end
