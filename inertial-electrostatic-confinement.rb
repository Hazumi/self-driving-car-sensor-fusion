class StoreClassifications
  def initialize(advertisement, classifier)
    @advertisement, @classifier = advertisement, classifier
  end

  def execute!
    ActiveRecord::Base.transaction do
      advertisement.update_attributes(category_id: classified_category_id)
      advertisement.classified!
    end
  rescue Vector::ZeroVectorError => e
    Rails.logger.error "error classifying advertisement #{advertisement.id}: #{e.message}"
  end

  private

  attr_reader :advertisement, :classifier

  def classified_category_id
    @classified_category_id ||= classifier.classify(advertisement.title)
  end
end
