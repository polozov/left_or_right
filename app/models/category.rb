class Category < Ohm::Model
  attribute  :name
  unique     :name
  collection :elements, :Element

  index :id
  index :name
  index :elements

  def validate
    assert_present :name
    assert_length  :name, 3..15
  end

  def self.divination category_id
    Category[category_id].elements.to_a.sample(2)
  end
end