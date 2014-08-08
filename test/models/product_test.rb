require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "product_attribtues_must_not_be_empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:price].any?
  	assert product.errors[:image_url].any?
  end

  test "product_price_must_be_positive" do
  	product = Product.new(title: "My book title",
  						   description: "yyy",
  						   image_url: "zzz.jpg")
  	product.price = -1
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"], 
  		product.errors[:price]

  	product.price = 0
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"],
  		product.errors[:price]

  	product.price = 1
  	assert product.valid?
  end

  def new_product(image_url)
  	Product.new(title: "My book title",
  		        description: "xyz",
  		        price: 1,
  		        image_url: image_url)
  end

  test "image_url" do
  	ok = %w{fred.gif fred.jpg fred.png http://uber.com/s/josh.jpg}
  	bad = %w{fred.doc hello.doc fred.gif/more joshua.fjf.more}
  	ok.each do |name|
  		assert new_product(name).valid?, "#{name} should be valid"
  	end
  	bad.each do |name|
  		assert new_product(name).invalid? "#{name} should not be valid"
  	end
  end

  test "product is not valid without a unique title" do
  	product = Product.new(title: products(:ruby).title,
  						   description: "yyy",
  						   image_url: "fred.gif",
  						   price: 1)
  	assert product.invalid?
  	assert_equal ["has already been taken"], product.errors[:title]
  end




end
