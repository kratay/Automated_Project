require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "selenium/client/idiomatic"
require "selenium/client/vendaqa/info"
require "selenium/client/vendaqa/commons"
require "selenium/client/vendaqa/checkout"
require "selenium/client/vendaqa/vcp"



class Untitled <  Test::Unit::TestCase	 

	include Selenium::Client::Vendaqa::Commons
	include Selenium::Client::Vendaqa::Checkout	
	include Selenium::Client::Vendaqa::VCP
	
	OS_sOrderSumTxt = "Please review and complete your order" # Text Showing
	OS_sTitleOrderRecipt = "YOUR RECEIPT" # Text showing Your Receipt
	OS_sTitleGiftCert = "Gift Certificates" # Text showing
	OS_sTitleBasket = "Your Shopping Cart" # Text showing
	OS_sTitleReedeem = "REDEEM A PROMOTION CODE" # Text showing	
	
	Product = Struct.new(:name, :price, :qty, :totprice, :address);
	OrderTot = Struct.new(:subtot, :packing, :discount, :ordertot, :deliveryoption);
	Payment = Struct.new(:cardtype, :cardno, :cardname, :startmn, :startyr, :endmn, :endyr, :securecode);
	#CO_RedeemCode = "123456"
	CO_GiftCertCode = "323NAIJ4412671265" 
		
	def setup
		@verification_errors = []
		@session = Selenium::Client::Driver.new \
		  :host => $gsHost,
		  :port => $giPort,
		  :browser => $gsBrowser,
		  :url => $gsURL,
		  :timeout_in_second => $giTimeOut
		@session.start_new_browser_session('commandLineFlags' => '--disable-web-security')
		@session.window_maximize		
	end

	def teardown
		#@session.closeBrowser
		assert_equal [], @verification_errors
	end	

	def test_untitled	

		@session.open "/page/home"
		@session.wait_for_page_to_load;	
		#self.selectRegion	
	####################################  Registered > Checkout #######################################		
		#self.registCheckout01(OS_sOrderSumTxt, OS_sTitleOrderRecipt); #CO01:
		
		# Update sku is Pre-Order #
		mainSession = @session
		self.UpdateVCPWindows($PreOrdSKU, "12/10/2011", 1000, "15/10/2011"); # Existing value "" ,1000, ""
		@session = mainSession; mainSession = nil;
		
		self.registCheckout02(OS_sTitleGiftCert, OS_sTitleBasket, OS_sOrderSumTxt, OS_sTitleOrderRecipt, OS_sTitleReedeem, $gsPromoCode) # CO02: 
=begin
		self.registCheckout03(OS_sOrderSumTxt, OS_sTitleOrderRecipt, OS_sTitleReedeem, $gsPromoCode) # CO03: 
		self.registCheckout04(OS_sTitleGiftCert, OS_sTitleBasket, OS_sOrderSumTxt, OS_sTitleOrderRecipt, OS_sTitleReedeem, $gsPromoCode) # CO04: 
		
	#################################### Checkout > New Register #######################################		
		self.checkoutNewRegist01(OS_sOrderSumTxt, OS_sTitleOrderRecipt); # CO05: Add Product to Basket, Checkout, and New Register then Checkout by Credit Card only.
		self.checkoutNewRegist02(OS_sTitleGiftCert, OS_sTitleBasket, OS_sOrderSumTxt, OS_sTitleOrderRecipt, OS_sTitleReedeem, $gsPromoCode); # CO06: 
		self.checkoutNewRegist03(OS_sOrderSumTxt, OS_sTitleOrderRecipt, OS_sTitleReedeem, $gsPromoCode, CO_GiftCertCode); # CO07: Checkout with credit card and redeem gift certificate
		self.checkoutNewRegist04(OS_sOrderSumTxt, OS_sTitleOrderRecipt, OS_sTitleReedeem, $gsPromoCode, CO_GiftCertCode) # CO08: Add normal/attribute/pre-order product to Basket, Checkout, New Register, use Redeem Promotion, Checkout with Redeem gift certificate."
		
	##################################### Express Checkout ###############################################
		self.expCheckout01(OS_sOrderSumTxt, OS_sTitleOrderRecipt); # CO09: Add normal Product then Express Checkout and Checkout by Credit Card only.
		self.expCheckout02(OS_sTitleGiftCert, OS_sTitleBasket, OS_sOrderSumTxt, OS_sTitleOrderRecipt, OS_sTitleReedeem, $gsPromoCode); # CO10: Add normal/attribute/pre-order/gift cert. product then Express Checkout and Checkout by Redeem Promotion & Credit Card.
=end		
	end

end