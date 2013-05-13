class Category < Ohm::Model
  attribute  :name
  unique     :name
  collection :elements, :Element

  index :name
  index :elements

  def validate
    assert_present :name
    assert_length  :name, 3..15
  end

end