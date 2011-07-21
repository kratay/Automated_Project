require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "selenium/client/idiomatic"
require "selenium/client/vendaqa/info"
require "selenium/client/vendaqa/basket"
require "selenium/client/vendaqa/customer"
require "selenium/client/legacy_driver"	
require "selenium/client/vendaqa/vcp"	


class Untitled <  Test::Unit::TestCase	  
	
	include Selenium::Client::Vendaqa::Commons
	include Test::Unit::Assertions
	include Selenium::Client::Vendaqa::VCP
	
	@@loctgotoBasket = "css=a#minicart_items" # "//span[@id='updateItems']" # locator of Item in minicart for goto Basket page
	@@loctgotoBasketNotEmpty = "//ul[@class='items_added']/li[@class='items']/a"
	@@loctBasketPage = "//div[@id='yourbasket']/h1" # locator of Basket object for checking Basket page load

	@@loctBasketCount = "//div[@class='ordertable']/table[@summary='Item information']/tbody/tr[@class='standarditem']"			

	## Locator of get value in Basket: use @@loctBasketBody first then 
	## Insert "/tr.position[?]" command behind @@loctBasketBody
	## The latest is @@loctBasketBodyName....					
	@@loctBasketBody = "//div[@class='ordertable']/table[@summary='Item information']/tbody"
	@@loctBasketBodyStr = "//tbody/tr"  # it's added [index] after
	@@loctBasketBodySKU = "/td[@class='name']/span[@class='sku']"
	@@loctBasketBodyName = "/td[@class='name']/a"
	@@loctBasketBodyPrice = "/td[@class='priceeach']" 
	@@loctBasketBodyQTY = "/td[@class='quantity']/input[starts-with(@id,'formsetqty')]" # use the get_value() funct.
	@@loctBasketBodyTotPrice = "/td[@class='totalprice']"
	@@locctBasketBodyRemove = "/td[@class='remove']/a"
	
	# Group of loctBasket
	@@loctBasketBody = [@@loctBasketCount, @@loctBasketBodyStr, @@loctBasketBodySKU, @@loctBasketBodyName, @@loctBasketBodyPrice, @@loctBasketBodyQTY, @@loctBasketBodyTotPrice, @@locctBasketBodyRemove]
	@@loctBasketSubTot = "//tr[@class='orscSubtotal']/td[@class='subtotal']/div"	# for SubTotal in ordersub
	
	@@loctQTYUpd = "//tr[1]/td[@class='quantity']/input[starts-with(@id,'formsetqty-')]"  # "//input[starts-with(@name,'setqty-')]" # for input QTY
	@@loctRemoveItem = "//tr[1]/td[@class='remove']" # for remove Item
	@@loctPromoBox = "//div[@class='promobdr']/div[@class='promofield']/input[@id='vcode']" # for input Promotion code
	@@loctPromoBtn = "//div[@class='promobdr']/div[@class='promofield']/input[@type='submit']" # for click GO button for promotion case

	@@loctContShopBtn = "link=Continue Shopping" #  "//div[@id='buttons']/a" # for click Continue Shopping button
	@@loctUpdBasketBtn = "link=Update Basket" # "//div[@id='buttons']/input[@value='Update Basket']" # For click Update Basket button		
	
	@@loctBasketContShop = "//div[@class='container containerorscempty basketR']/h1" # For click Continue button when already input "0" qty.

	@@loctGetBasketEmpty = "//div[@class='container containerorscempty basketR']/p" # for get text Basket Empty
	@@loctContShoppingEmpt = "//div[@class='container containerorscempty basketR']/div[@id='buttons']/a[@class='right']/img[@alt='Continue Shopping']" # for click Continute Shopping in Basket empty page		
		
	# Locator for check out not yet login
	@@loctChkoutBasketBtn = "//div[@id='buttons']/input[@value='Checkout']" # for click Checkout button
	@@loctLoginafterCheckout = "//ul[@class='checkoutStepIndicators']/li[@class='checkoutLoginOn']" # For checkout before login, it shows login before order sum page is shown.
	
	# Locator for login before checkout
	@@loctRgstEmailText = "css=input#email" # "//div[@class='registered']/input[@name='email']"	# For Email textbox
	@@loctRgstPwdText = "css=input#password" # "//div[@class='registered']/input[@name='password']" # For Password textbox
	@@loctRgstSubmitBtn = "css=input.right.submit" # "//div[@class='registeredbtn']/input[@class='right submit']" # For Submit button
	
	# Locator for checking Order Summary page is shown.
	@@loctOrdSumPage = "//p[@class='confirmationInstructions']"
		
	@@loctHomepage = "img#logo" # Goto Homepage
	$gsMatchProdDetail = "shows matching with Add To Basket in Product Detail"
		
	def setup
		@verification_errors = []
		@seleniumnew = Selenium::Client::Vendaqa::Basket.new
		@seleniumnew.connectBrowser	
	end

	def test_untitled	
		iQty = 0;
		bReturn = @seleniumnew.chkBasketIsEmpty(@@loctgotoBasket); # check basket IsEmpty?
		if bReturn == false
			@seleniumnew.gotoBasketPage(@@loctgotoBasket, @@loctBasketPage, "BS-PreCondition", "Goto Basket page.");
			@seleniumnew.removeAllItem(@@loctBasketBody, @@loctContShoppingEmpt, "Remove all item.", "BS-12");	
			@seleniumnew.gotoContinueShopping(@@loctContShoppingEmpt, @@loctHomepage, "BS-02", "Click Continue Shopping in empty basket then re-direct to Homepage"); # BS02 - Continue Shopping in blank Basket					
		end		
				
		@seleniumnew.gotoBasketPage(@@loctgotoBasket, @@loctGetBasketEmpty, "BS-01", "Basket page is empty.");
		@seleniumnew.gotoContinueShopping(@@loctContShoppingEmpt, @@loctHomepage, "BS-02", "Click Continue Shopping in empty basket then re-direct to Homepage"); # BS02 - Continue Shopping in blank Basket
		
		## Get info. from VCP ##
		mainSession = @seleniumnew	
		prodInfo = self.getVCPNormalProduct($PD_aProd1[0])		
		@seleniumnew = mainSession; mainSession = nil;
		#########################				
		
		#@seleniumnew.pstAddCorrToBasket($PD_aProd1, "1", true); puts "BS-03: Add Product completed."; # BS03 - Add Product 
		@seleniumnew.addProductToBasket(prodInfo, "BS-03(PreCondition)", "Add Product to Basket", 1, true);		
		@seleniumnew.gotoBasketPage(@@loctgotoBasket, @@loctBasketPage, "BS-03(PreCondition)", "Goto Basket page.");
		@seleniumnew.gotoContinueShopping(@@loctContShopBtn, @@loctHomepage, "BS-03", "Click Continue Shopping in Basket page then re-direct to Homepage"); puts "BS03 - Then click Continue Shopping completed."; # BS03 - Then click Continue Shopping		
		iQty = 2;			
		#@seleniumnew.pstAddCorrToBasket($PD_aProd1, "1", true); puts "BS-04 - Add Product completed."; # BS04 - Add Product	
		@seleniumnew.addProductToBasket(prodInfo, "BS-04(PreCondition)", "Add Product to Basket", 1, true);					
		@seleniumnew.gotoBasketPage(@@loctgotoBasket, @@loctBasketPage, "BS-04(PreCondition)", "Goto Basket page.");
		mySubTot = @seleniumnew.chkItemTotalPrice(@@loctBasketBody, @@loctBasketSubTot, "BS-04"); puts "BS04 - then check total price completed."; # BS04 - then check total price
		@seleniumnew.chkItemSubTotal(@@loctBasketSubTot, mySubTot, "BS-04"); puts "BS-04 - then Check sub total completed."; # BS04 - then Check sub total			
		@seleniumnew.chkMatchProductBody($PD_aProd1, @@loctBasketBody, iQty, "Check Product Name, Price, and QTY.", "BS-06,BS-07,BS-08"); #puts "BS-06 - BS08 check Product Name, Price ,Qty completed."; # BS06 - BS08 check Product Name, Price ,Qty
	
		@seleniumnew.chkUpdateQTY(@@loctQTYUpd, @@loctUpdBasketBtn, "", "", false, "Leave blank in QTY box.", "BS-09"); #puts "BS09 - Leave blank in Qty box completed"
		@seleniumnew.chkUpdateQTY(@@loctQTYUpd, @@loctUpdBasketBtn, "QA", "", false, "Input character in QTY box.", "BS-10"); #puts "BS10 - Input character in QTY box completed"
		
		iQty = 3;
		#@seleniumnew.pstAddCorrToBasket($PD_aProd1, "1", true); puts "BS-11 - Input number in QTY box completed";
		@seleniumnew.addProductToBasket(prodInfo, "BS-11(PreCondition)", "Add Product to Basket", 1, true);	
		@seleniumnew.gotoBasketPage(@@loctgotoBasket, @@loctBasketPage, "BS-11(PreCondition)", "Goto Basket page.");
		mySubTot = @seleniumnew.chkItemTotalPrice(@@loctBasketBody, @@loctBasketSubTot, "BS-11"); #puts "BS-11 - check Total Price completed";
		@seleniumnew.chkItemSubTotal(@@loctBasketSubTot, mySubTot, "BS-11"); puts "BS-11 - check Sub Total completed";
		@seleniumnew.chkMatchProductBody($PD_aProd1, @@loctBasketBody, iQty, "Check Product Name, Price, and QTY.", "BS-11");
		
		#@seleniumnew.pstAddCorrToBasket($PD_aProd2, "1", true); puts "BS-12 - Add Product completed.";
		@seleniumnew.addProductToBasket($PD_aProd2, "BS-12(PreCondition)", "Add Product to Basket", 1, true);	
		@seleniumnew.gotoBasketPage(@@loctgotoBasket, @@loctBasketPage, "BS-12(PreCondition)", "Goto Basket page.");
		mySubTot = @seleniumnew.chkItemTotalPrice(@@loctBasketBody, @@loctBasketSubTot, "BS-12"); #puts "BS12 - check Total Price completed";
		@seleniumnew.chkItemSubTotal(@@loctBasketSubTot, mySubTot, "BS-12"); #puts "BS-12 - check Sub Total completed";
		@seleniumnew.chkRemoveItem(@@loctBasketBody, @@loctBasketSubTot, @@loctContShoppingEmpt, "BS-12", "Remove Item."); #puts "BS-12 - then Remove Product completed";
		
		#@seleniumnew.pstAddCorrToBasket($PD_aProd2, "1", true); puts "BS-13 - Add Product completed";
		@seleniumnew.addProductToBasket($PD_aProd2, "BS-13(PreCondition)", "Add Product to Basket", 1, true);	
		@seleniumnew.gotoBasketPage(@@loctgotoBasket, @@loctBasketPage, "BS-13(PreCondition)", "Goto Basket page.");
		mySubTot = @seleniumnew.chkItemTotalPrice(@@loctBasketBody, @@loctBasketSubTot, "BS-13"); # puts "BS-13 - check Total Price completed";
		@seleniumnew.chkItemSubTotal(@@loctBasketSubTot, mySubTot, "BS-13"); # puts "BS-13 - check Sub Total completed"; 			
		#@seleniumnew.chkRemoveItem(@@loctBasketBody, @@loctBasketSubTot, @@loctContShoppingEmpt, "BS-13"); puts "BS13 - then Remove Product completed";
		@seleniumnew.removeAllItem(@@loctBasketBody, @@loctContShoppingEmpt, "Remove all item.", "BS-13"); # puts "Remove all Item then goto blank Basket page."; # Remove All Item.			
		
		#BS14 - Not yet logged In then add product and checkout.
		#@seleniumnew.pstAddCorrToBasket($PD_aProd1, "1", true);
		@seleniumnew.addProductToBasket(prodInfo, "BS-14(PreCondition)", "Add Product to Basket", 1, true);	
		@seleniumnew.gotoBasketPage(@@loctgotoBasket, @@loctBasketPage, "BS-14(PreCondition)", "Goto Basket page.");
		@seleniumnew.gotoCheckoutPage(@@loctChkoutBasketBtn, @@loctLoginafterCheckout , "BS-14(PreCondition)", "Click Check Out button not yet login. Should show Login page.");
		@seleniumnew.loginUser(@@loctRgstEmailText, 
			@@loctRgstPwdText, 
			@@loctRgstSubmitBtn,  
			$gsExistUserCredit, 
			$gsExistPassCredit, 
			"BS-14",
			"Login user then show Order Summary page.", 
			@@loctOrdSumPage,
			true);
		#self.clickButton(@@loctHomepage); # Goto Homepage
		@seleniumnew.logoutUser($loctGotoLogout, "BS-14", "Logout User to completed this."); # Logout			

		#BS15 - Logged In then add product and checkout
		@seleniumnew.gotoLogin($loctGotoLogin); # Goto Login page.			
		@seleniumnew.loginUser(@@loctRgstEmailText, 
			@@loctRgstPwdText, 
			@@loctRgstSubmitBtn,  
			$gsExistUserCredit, 
			$gsExistPassCredit, 
			"BS-15",
			"Login user then show Order Summary page.", 
			@@loctOrdSumPage,
			true);						
		@seleniumnew.pstAddCorrToBasket($PD_aProd1, "1", true);
		@seleniumnew.gotoBasketPage(@@loctgotoBasket, @@loctBasketPage, "BS-15(PreCondition)", "Goto Basket page.");
		@seleniumnew.gotoCheckoutPage(@@loctChkoutBasketBtn, @@loctLoginafterCheckout , "BS-15(PreCondition)", "Click Check Out button not yet login. Should show Login page.");
		@seleniumnew.loginUser(@@loctRgstEmailText, 
			@@loctRgstPwdText, 
			@@loctRgstSubmitBtn,  
			$gsExistUserCredit, 
			$gsExistPassCredit, 
			"BS-15",
			"Login user then show Order Summary page.", 
			@@loctOrdSumPage,
			true);
		#self.clickButton(@@loctHomepage); # Goto Homepage
		@seleniumnew.logoutUser($loctGotoLogout, "BS-15", "Logout User to completed this."); # Logout		
				
		self.writeResult("BS-END" , "Finsished to execute", "Done", "Finished")
		
	end

	
	def teardown
		#@seleniumnew.closeBrowser
		assert_equal [], @verification_errors
	end
  
end
