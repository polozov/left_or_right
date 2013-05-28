describe Element do
  context 'has valid factory :element' do
    subject{FactoryGirl.create(:element)}

    its(:name)     {should match /test_element/}
    its(:image)    {should be_kind_of(Rack::Test::UploadedFile)}
    # vote counter
    its(:score)    {should eql(0)}
    # array of users who voted
    its(:voted)    {should be_kind_of(Ohm::MutableSet)}
    # relationships between categories and a elements
    its(:category) {should be_kind_of(Category)}
    # new element get id automatic from Ohm
    its(:id)       {should be}
    it{should be_valid}
  end

  context 'object' do
    it 'is invalid with long name' do
      expect(FactoryGirl.build(:element, name: 'very_long_element_name')).
        to_not be_valid
    end

    it 'is invalid with short name' do
      expect(FactoryGirl.build(:element, name: 'el')).to_not be_valid
    end

    it 'is invalid without name' do
      expect(FactoryGirl.build(:element, name: '')).to_not be_valid
    end
  end

  context "method 'delete'" do
    it 'should delete elements image after element destroy' do
      test_element = FactoryGirl.create(:element)
      expect(File.exist?(
        Rails.root.join('app', 'assets', 'images', test_element.image))).to be_true

      test_element.delete
      expect(File.exist?(
        Rails.root.join('app', 'assets', 'images', test_element.image))).to be_false
    end
  end

  context "method 'upload'" do
    it 'should not upload image if image has non accepted (jpg/jpeg/png) extension' do
      expect(FactoryGirl.create(:element, image: 'test.doc')).to raise_error
    end
  end

  context "method 'vote_up'" do
    it 'should increment element score for user who not voted and 
      not increment for user who voted' do

      user    = FactoryGirl.create(:user)
      element = FactoryGirl.create(:element)
      # first time
      expect{element.vote_up(user.id)}.to change{element.score}.from(0).to(1)
      # second time
      expect{element.vote_up(user.id)}.to_not change{element.score}
    end
  end 
end
