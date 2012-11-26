class Translation
  include Mongoid::Document
  include Houdini::Model

  field :houdini_request_time, type: DateTime
  field :houdini_translation, type: Hash, default: {}

  houdini :spanish_translation_2,{
    :input => {
      :product_description => "Test description.",
      :product_name => :product_name,
      :product_url => "http://example.com",
      :image_url => "http://example.com/image.jpg"
    },
    :on => :after_create,
    :after_submit => :after_houdini_sent,
    :on_task_completion => :process_translation_answer
  }

  def product_name
    "Test Product"
  end

  def after_houdini_sent
    self.update_attributes(houdini_request_time: Time.now)
  end

  def process_translation_answer(params, verbose={})
    self.update_attributes(houdini_translation: params)
  end
end
