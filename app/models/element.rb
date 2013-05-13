class Element < Ohm::Model
  attribute :name
  # unique    :name
  attribute :path
  counter   :score
  reference :category, :Category

  index :name

  def validate
    assert_present :name
    assert_length  :name, 3..15
    assert_present :path
  end

  # def before_create
  #   self.score = '1'
  # end

end