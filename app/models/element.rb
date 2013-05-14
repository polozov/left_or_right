class Element < Ohm::Model
  attribute :name
  attribute :path
  counter   :score
  reference :category, :Category

  index :name
  index :category

  def validate
    assert_present :name
    assert_length  :name, 3..15
    assert_present :path
  end
end