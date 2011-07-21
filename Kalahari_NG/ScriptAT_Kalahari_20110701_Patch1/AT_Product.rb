require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "selenium/client/idiomatic"
require "selenium/client/vendaqa/info"
require "selenium/client/vendaqa/product"
require "selenium/client/vendaqa/commons"
require "selenium/client/legacy_driver"	


class Untitled <  Test::Unit::TestCase	  
	
	include Selenium::Client::Vendaqa::Commons
	include Test::Unit::Assertions
		
	#$loctSortBy = "//div[@id='uniform-sortby']/select[@id='sortby']/option"
		
	def setup
		@verification_errors = []				
		#@selenium = self.connectBrowser
		@seleniumnew = Selenium::Client::Vendaqa::Product.new
		@seleniumnew.connectBrowser	
	end

	def teardown
		#@seleniumnew.closeBrowser
		assert_equal [], @verification_errors
	end

	def test_untitled			
		@seleniumnew.selectRegion;
		@seleniumnew.searchText($loctSrhBox, $loctSrhSubmit, $PD_aProd1[0]);
		@seleniumnew.testProdResult($PD_aProd1);
				
		#@seleniumnew.testProdResult($gaProdRelease)
		#@seleniumnew.testProdResult($gaProdOutStock)
				
		#@seleniumnew.testProdResult($gaProdETA)	
		#@seleniumnew.testProdResult($PD_aProd1)					
	    begin
	        assert @seleniumnew.is_text_present("ERROR")		
			#self.writeResult("Product Detail", "ERROR", @verification_errors, "Failed")			
	    rescue Test::Unit::AssertionFailedError
	        @verification_errors << $!
			#self.writeResult("Product Detail", "ERROR", @verification_errors, "Failed")
	    end				 
	end
  
end
