describe Category do
  context 'has valid factory :category' do
    subject{FactoryGirl.create(:category)}

    its(:name)     {should match /test_category/}
    its(:image)    {should be_kind_of(Rack::Test::UploadedFile)}
    # relationships between categories and a elements
    its(:elements) {should be_kind_of(Ohm::Set)}
    # new category get id automatic from Ohm
    its(:id)       {should be}
    it{should be_valid}
  end

  context 'object' do
    it 'is invalid with long name' do
      expect(FactoryGirl.build(:category, name: 'very_long_category_name')).
        to_not be_valid
    end

    it 'is invalid with short name' do
      expect(FactoryGirl.build(:category, name: 'ca')).to_not be_valid
    end

    it 'is invalid without name' do
      expect(FactoryGirl.build(:category, name: '')).to_not be_valid
    end
  end

  context "method 'delete'" do
    it 'should delete categories image after category destroy' do
      test_category = FactoryGirl.create(:category)
      expect(File.exist?(
        Rails.root.join('app', 'assets', 'images', test_category.image))).to be_true

      test_category.delete
      expect(File.exist?(
        Rails.root.join('app', 'assets', 'images', test_category.image))).to be_false
    end
  end

  context "method 'upload'" do
    it 'should not upload image if image has non accepted (jpg/jpeg/png) extension' do
      expect(FactoryGirl.create(:category, image: 'test.doc')).to raise_error
    end
  end

  context "method 'name_unique?'" do
    it 'should return false if category name non unique and true in other way' do
      test_category       = FactoryGirl.create(:category, name: 'category_name')
      unique_category     = FactoryGirl.build(:category, name: 'unique_name')
      non_unique_category = FactoryGirl.build(:category, name: 'category_name')

      expect(unique_category.name_unique?).to be_true
      expect(non_unique_category.name_unique?).to be_false
    end
  end

  context "method 'name_unique?'" do
    it 'should return false if category name non unique and true in other way' do
      unique_name = SecureRandom.hex(8).to_s

      test_category       = FactoryGirl.create(:category, name: "#{unique_name}_1")
      unique_category     = FactoryGirl.build(:category, name: unique_name)
      non_unique_category = FactoryGirl.build(:category, name: "#{unique_name}_1")

      expect(unique_category.name_unique?).to be_true
      expect(non_unique_category.name_unique?).to be_false
    end
  end

  context "method 'self.divination'" do
    before(:all) do
      @test_category = FactoryGirl.create(:category)
      3.times{ FactoryGirl.create(:element, category: @test_category) }
    end

    it 'should return an array' do
      expect(Category.divination(@test_category.id)).to be_kind_of(Array)
    end

    it 'should return an array of two elements' do
      expect(Category.divination(@test_category.id).size).to eql(2)
    end

    it 'should return an array of two instance of Element class' do
      expect(Category.divination(@test_category.id).first).to be_kind_of(Element)
      expect(Category.divination(@test_category.id).last).to be_kind_of(Element)
    end
  end

  context "counter 'all_items'" do
    before(:all) do
      @test_category = FactoryGirl.create(:category)
      @test_element = FactoryGirl.create(:element, category: @test_category)
    end

    it 'should increased by 1 when a new element creating' do
      expect{FactoryGirl.create(:element, category: @test_category)}.to change{
        @test_category.all_items}.by(1)
    end

    it 'should decreased by 1 when a element deleting' do
      expect{@test_element.delete}.to change{@test_category.all_items}.by(-1)
    end
  end
end
