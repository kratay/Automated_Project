require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "selenium/client/idiomatic"
require "selenium/client/vendaqa/info"
require "selenium/client/vendaqa/product"
require "selenium/client/vendaqa/commons"
require "selenium/client/vendaqa/vcp"
require "selenium/client/legacy_driver"	


class Untitled <  Test::Unit::TestCase	  
	
	include Selenium::Client::Vendaqa::Commons
	include Test::Unit::Assertions
	include Selenium::Client::Vendaqa::VCP

		
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
		#@seleniumnew.selectRegion;
		
############ 1. Buy Now  #################################################################			
		@seleniumnew.searchText($loctSrhBox, $loctSrhSubmit, $PD_aProd1[0]);	
		@seleniumnew.getSearchResult($loctSrhResult);
		@seleniumnew.gotoProductDetail($PD_xPrdGoto);
		
		## Get info. from VCP ##
		mainSession = @seleniumnew	
		productDetails = self.getVCPNormalProduct($PD_aProd1[0])		
		@seleniumnew = mainSession; mainSession = nil;
		#########################		
		@seleniumnew.testProdPriceDisplay(productDetails, "Display correct price.", "PD-01");
		@seleniumnew.testProdNameDisplay(productDetails, "Display correct product name.", "PD-02");
		@seleniumnew.testProdSKUDisplay(productDetails, "Display correct SKU.", "PD-04");
		@seleniumnew.testProdDetailDisplay(productDetails, "Display correct product detail.", "PD-05");		
		sType = @seleniumnew.getBuyControlsType(productDetails);
						
		if productDetails[12] == true	# Attribute Product				
			iRDate = 8; iETADate = 9;
		elsif productDetails[12] == false
			iRDate = 3; iETADate = 5;
		end		
		@seleniumnew.testAddToBasket(productDetails, sType, false); # PD-10..PD-12, PD-33
		@seleniumnew.chkBuyControls(sType, productDetails[iRDate], productDetails[iETADate]); # PD-06..PD			
		@seleniumnew.testTellaFriend; # PD-50..PD-55
				
############ 2. Release Date  ############################			
		## Update Release Date to VCP. ##
		mainSession = @seleniumnew	
		self.UpdateVCPWindows($PreOrdSKU, "12/12/2011", 100, "");	
		productDetails = self.getVCPNormalProduct($PreOrdSKU);
		@seleniumnew = mainSession; mainSession = nil;
		#########################		
		@seleniumnew.searchText($loctSrhBox, $loctSrhSubmit, productDetails[1]);	
		@seleniumnew.getSearchResult($loctSrhResult);
		@seleniumnew.gotoProductDetail($PD_xPrdGoto);
		sType = @seleniumnew.getBuyControlsType(productDetails);
						
		if productDetails[12] == true	# Attribute Product				
			iRDate = 8; iETADate = 9;
		elsif productDetails[12] == false
			iRDate = 3; iETADate = 5;
		end			
		@seleniumnew.chkBuyControls(sType, productDetails[iRDate], productDetails[iETADate]); # PD-06..PD			
				
############ 3. Out of Stock & Email Me  ############################					
		## Update Out of Stock to VCP. ##
		mainSession = @seleniumnew	
		self.UpdateVCPWindows($PreOrdSKU, "12/12/2010", 0, "12/08/2011");
		productDetails = self.getVCPNormalProduct($PreOrdSKU);
		@seleniumnew = mainSession; mainSession = nil;
		#########################	
		@seleniumnew.searchText($loctSrhBox, $loctSrhSubmit, productDetails[1]);	
		@seleniumnew.getSearchResult($loctSrhResult);
		@seleniumnew.gotoProductDetail($PD_xPrdGoto);
		sType = @seleniumnew.getBuyControlsType(productDetails);
						
		if productDetails[12] == true	# Attribute Product				
			iRDate = 8; iETADate = 9;
		elsif productDetails[12] == false
			iRDate = 3; iETADate = 5;
		end			
		@seleniumnew.chkBuyControls(sType, productDetails[iRDate], productDetails[iETADate]); # PD-06..PD					
		@seleniumnew.testEmailMe(sType); # PD-44..PD-49
			 
	end
  
end
