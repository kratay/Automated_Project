require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "selenium/client/idiomatic"
require "selenium/client/vendaqa/info"
require "selenium/client/vendaqa/commons"
require "selenium/client/vendaqa/order"
require "selenium/client/vendaqa/vcp"


class Untitled <  Test::Unit::TestCase	  

	include Selenium::Client::Vendaqa::Commons
	include Selenium::Client::Vendaqa::Order
	include Selenium::Client::Vendaqa::VCP
	
	# Order T10251
	
	OS_sOrderSumTxt = "Please review and complete your order" #"ORDER SUMMARY" # Text Showing
	OS_sTitleBookAddr = "Your Address Book at Kalahari Nigeria" # "Your Address Book at Showcase" # Title page
	OS_sAddDeliveryAddr = "Add Delivery Address"	 # Title page
	OS_sTitleGiftWrap = "Gift Wrap at Showcase" # Title page
	OS_sTitleMultiAddr = "Multiple Delivery Addresses at Showcase" # Title page
	OS_sTitleNewAddrMultiAddr = "Delivery Details at Showcase" # Title page
	OS_sTitleContDetail = "Edit Contact Details" # Text showning 
	OS_sTitleRedeemProm = "Redeem a Promotion Code" # Text showing
	OS_sTitleBasket = "Your Shopping Cart" #"Shopping Basket" # Text showing 
	OS_sTitleOrderRecipt = "Your Receipt" # Text showing
	OS_sTitleMyAcct = "My Account Information" # Text showing
	OS_sTitleHomepage = "Home at Showcase" # Title page
	OS_sTitleEmpBasket = "Your shopping basket is empty." # text empty Basket page showing
	OS_sTitleMorePopup = "Delivery Rate" # Text showing
		
	CO_RedeemGiftCert = "323NAIJ4412671265" # Redeem Gift Certificate, 10000.00
	
	Product = Struct.new(:name, :price, :qty, :totprice, :address);
	OrderTot = Struct.new(:subtot, :packing, :discount, :ordertot, :deliveryoption);
	Payment = Struct.new(:cardtype, :cardno, :cardname, :startmn, :startyr, :endmn, :endyr, :securecode);
	addrBilling = ""
	addrDelivery = ""
	
	
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

	def test_untitled
		@session.open "/page/home"
		@session.wait_for_page_to_load			
		self.selectRegion		
		
####################################### Getting VCP Information ####################################### 		
		#mainSession = @session;
		
		#arryCustInfo = [sTitle, sFName, sMName, sLName, sCompany, sNum, sAddr1, sAddr2, sCity, sState, sPostcode, sCountry, sArea, sPhone, sAreaFax, sFax, sStoreCredit];
		#arryCustInfo = self.getVCPCustomerInfo("chic@venda.com");
		#puts arryCustInfo;
		
		#arryGiftWrap = self.getVCPGiftWrap
		#puts "Get GiftWrap = #{arryGiftWrap}"
				
		#giftCertNo = self.getVCPGiftCert("10199");
		#puts "Get giftcert as #{giftCertNo}";
		
		#sDelivery = self.getVCPDeliveryOption;
		#puts sDelivery;
		#@session = mainSession;
		#mainSession = nil;		
		
####################################### New Register (Pre-step) ####################################### 
		#self.gotoLoginPage;
		#self.newCustomer($gaContTrue); 
		
		# add product				
		iQty = 1;		
		bCanAdd, sResult, sProdName, sProdPrice = self.addProduct($P1SKU,iQty); 		
		sProdPrice = self.convertPrice(sProdPrice);		
		dTotPrice = 0; dTotPrice = sProdPrice.to_f * iQty.to_i;				
		structProdInfo = Product.new(sProdName, sProdPrice, iQty, dTotPrice); 			
			
		self.clickCheckout; # click checkout		
		#self.loginUser; # login user before checkout
		self.loginUserExist($gsExistUser, $gsExistPass)

		
####################################### Delivery Address #######################################							
		#arryCustInfo = [sTitle, sFName, sMName, sLName, sCompany, sNum, sAddr1, sAddr2, sCity, sState, sPostcode
		#, sCountry, sArea, sPhone, sAreaFax, sFax, sStoreCredit];
		mainSession = @session;
		addrDelivery = self.getVCPCustomerInfo($gsExistUser);			
		@session = mainSession; mainSession = nil;	
		puts addrDelivery;		
		self.checkDeliveryAddr(addrDelivery);  # OS01: check Delivery Address in Order Summary					
		self.clickEditToBookPage(OS_sTitleBookAddr); # OS02: Redirect to Your address book page when click Edit link		
		self.clickDoneInBookPage; # OS03: Click Done in Book Address then it re-direct Order Summary page.
		self.gotoDeliveryAddress; # OS04: Click "Add New Address" then goto Add delivery address page.
		self.inputBlankDeliverAddr; # OS05: Input blank for the field that have '*'
		self.inputCharPhoneDeliverAddr($gaOSContactFalse); # OS06: Input character in phone number field.
		structProdInfo.address = self.newDeliveryAddr($gaOSContactTrue); # OS07: Input Delivery Address completely. It's shown new Delivery Address correctly.
		addrDelivery = structProdInfo.address;
		structProdInfo.address  = self.selectDeliverAddrOpt; # OS08: Select radio button in Delivery Address then click Done. It has been shown Delivey Address correctly.
		addrDelivery = structProdInfo.address;		

####################################### Delivery Option #######################################				
		self.chkDeliveryOption; # OS09: Delivery option display correctly.
		self.chkMoreInfoPopup(OS_sTitleMorePopup); # OS10: Click More Info button then Delivery popup page appear.
		self.testDeliveryOptChg; # OS11: Delivery option was changed. Postage & Packaging price was changed.

####################################### Product Information #######################################					
		self.chkProdName(structProdInfo.name); # OS13: Product name display correctly.
		self.chkProdPrice(structProdInfo.price); # OS14: Product price each display correctly.
		self.chkProdQTY(structProdInfo.qty); # OS15: Product quantity display correctly.
		self.chkProdTot(structProdInfo.totprice); # OS16: Total Price display correctly.
=begin		
####################################### Gift Wrap #######################################			
		self.clickGiftWrap(OS_sTitleGiftWrap); # OS17: Redirect to Gift wrap page.
		self.clickCancel; # OS18: Click Cancel then re-direct to Order Summary page.
		self.clickContinue; # OS19: Click Continue then redirect to Order Summary page.
		#self.chkWrapItemDropDown(OS_sOrderSumTxt); # OS20: See at "Wrap Item?" dropdown, Wrap type display correctly.
		self.chkProdNameAddrGF(structProdInfo); # OS21: In Gift Wrap page, Product name and Delivery address display correctly.	
		self.chkProdPriceGF(structProdInfo.price); # OS22: In Gift Wrap page, Product price display correctly.		
		self.chkTypeMsgGFCancel("Type Message"); # OS23: Select wrap type or type message and Click "Cancel" button then re-direct to Order Summary page.
		#self.chckSelectGFCont; # OS24: Select wrap type and Click "Continue" button then re-direct to Order Summary page.
		self.chkTypeMsgGFCont("New Message"); # OS25: Type message and click Continue button Gift message updated. Redirect to Order Summary page.
		#self.chkSelectTypeMsgGF("New again Message"); # OS26: Select Wrap Item, type message and Click Continue button then
		
####################################### Multiple Delivery Address #######################################			
		self.gotoMultiAddr(OS_sTitleMultiAddr); # OS27: Click at "Ship this item to different address" link Redirect to Multiple delivery addresses page.
		self.chkMultiAddrDone; # OS28: In Multiple delivery addresses page and Click at "Done" button. Re-direct to Order Summary page.
		self.chkMultiProdInfo(structProdInfo); # OS29 - OS31: Product information display correctly.
		# self.updMLCharQty(OS_sTitleMultiAddr)  #OS33: Enter character in Qty box and Click at "Update Quantities" button. Re-direct to ........
		self.updMLQty(2, OS_sTitleMultiAddr); # OS34: Input Qty box and Click at "Update Quantities" button. It should be expand item row follow updated quantity.
		self.updMLBlankQTY(OS_sTitleMultiAddr, OS_sTitleEmpBasket) # OS32: Input blank in QTY box then that product was deleted.
		result =  self.clickNewAddrML(OS_sTitleMultiAddr, OS_sTitleNewAddrMultiAddr) # OS35: Click Add New Address then re-direct to Your address book page.			
		puts "Finished : OS35, result : #{result}"
		if result == $gsPASS then			
			self.gotoMultiAddrfromBasket;
			self.gotoMultiAddr(OS_sTitleMultiAddr);
		end		
		self.selectMLAddrDone(OS_sTitleMultiAddr, OS_sOrderSumTxt) #OS36: Select Delivery in dropdown and Click at "Done" button. Re-direct to Order Summary page and update Delivery Address correctly.		
=end
#################################### Order Summary #######################################			
		subTot, pack, orderTot, deliveryOpt = self.chkOrderSummaryPart(OS_sOrderSumTxt); # OS45: Order summary area display correctly.
		structOrderTot = OrderTot.new(subTot, pack, 0.00, orderTot, deliveryOpt); 		

#################################### Redeem Promotion #######################################
		self.clickRedeemProm(OS_sOrderSumTxt, OS_sTitleRedeemProm); # OS37: Click at Redeem a Promotion Code link, Goto Redeem a Promotion Code page.
		self.inputBlankRedeemProm(OS_sTitleRedeemProm); # OS38: In Redeem a Promotion Code page, Leave field blank and Click at Apply button.
		self.inputInCorrRedeemProm(OS_sTitleRedeemProm, "Incorrect"); # OS39: In Redeem a Promotion Code page, Enter invalid code and Click at Apply button.
		self.inputCancelCorrRedeemProm(OS_sTitleRedeemProm, "", structOrderTot) # OS40: In Redeem a Promotion Code page, Enter valid code and Click at Cancel button.
		structOrderTot.subtot, structOrderTot.packing, structOrderTot.discount, structOrderTot.ordertot = self.inputCorrRedeemProm(OS_sOrderSumTxt, OS_sTitleRedeemProm, $gsPromoCode, $gsPromoPercent, structOrderTot); # OS41: In Redeem a Promotion Code page, Enter valid code and Click at Cancel button.		
=begin		
#################################### Redeem Gift Certificate #######################################		
		self.inputBlankReGiftCert(OS_sOrderSumTxt); # OS42: In Redeem a Gift Certificate area, Leave field blank and Click at Apply button.
		self.inputIncorrReGiftCert(OS_sOrderSumTxt, "1234"); # OS43: In Redeem a Gift Certificate area, Enter invalid promotion code and Click at Apply button.
		self.inputCorrReGiftCert(OS_sOrderSumTxt, CO_RedeemGiftCert) # OS44: In Redeem Gift Cert., valid gift cert code and apply.
=end		
#################################### Edit Contact Details (Billing) #######################################				
		addrBilling = self.getBillContDetailAddr;	puts "Finished getBillContDetailAddr"			
		self.clickEditCont(OS_sOrderSumTxt, OS_sTitleContDetail); # OS46: In Contact address area and Click Edit link. Go to Edit contact details page correctly.				
		self.inputBlankContDetail(OS_sTitleContDetail); # OS47: Edit Contact Detail, input blank for the field that have '*'
		self.inputCharPhoneContDetail(OS_sTitleContDetail); # OS48: Edit Contact Detail, input character in Phone box.
		self.clickPrevContDetailToOS(OS_sTitleContDetail, OS_sOrderSumTxt); # OS49: Edit Contact Detail data in the fields and Click Previous button. Re-direct to Order Summary page.
		addrBilling = self.clickContinueUpdateContDetait(OS_sOrderSumTxt, OS_sTitleContDetail, $gaOSBillContactTrue); # OS50: Updating contact detail then re-direct to Order Summary page and Contact address was updated.
	
#################################### Payment Detail #######################################
		self.clickBackToBag(OS_sOrderSumTxt, OS_sTitleBasket) # OS51: In Order Summary page, Click Back to Bag button then Go to Basket page.
		self.placeOrderInputBlank(OS_sOrderSumTxt) # OS52: In Order Summary page, Leave require field blank and Click Place Your Order button
		self.placeOrderInputChar(OS_sOrderSumTxt) # OS53: In Order Summary page, Input character to Credit Card Number and Click Place Your Order button
		
		crdType, crdNo, crdName, crdStMn, crdStYr, crdEndMn, crdEndYr, crdCode = self.placeCorrOrder(OS_sOrderSumTxt, OS_sTitleOrderRecipt) # OS54: In Order Summary page, input payment information and Click Place Your Order button Re-direct to Order receipt page.		
		structPayment = Payment.new(crdType,crdNo,crdName,crdStMn,crdStYr,crdEndMn,crdEndYr,crdCode);
	
#################################### Order Receipt #######################################		
		self.chkDeliveryAddrOR(OS_sTitleOrderRecipt, addrDelivery)  # OR01: Delivery address display correctly.
		self.chkDeliveryOptionOR(OS_sTitleOrderRecipt, structOrderTot.deliveryoption) # OR02: Delivery option display correctly.
		self.chkProdInfoOR(OS_sTitleOrderRecipt, structProdInfo)  # OR03: Product Information display correctly.
		self.chkOrderSummOR(OS_sTitleOrderRecipt, structOrderTot)  # OR04: Order Summary display correctly.
		self.chkPaymentOR(OS_sTitleOrderRecipt, structPayment)  # OR05: Payment detail display correctly.		
		self.chkContactDetailOR(OS_sTitleOrderRecipt, addrBilling)  # OR06: Contact detail display correctly.			
		self.clickMyAcctORToLogin(OS_sTitleOrderRecipt); ### OR07: Click at "My Account" button then Go to Log in page. -> You should login before		
		## Not Run this case ## self.clickMyAcctORToAC(OS_sTitleOrderRecipt, OS_sTitleMyAcct);	### OR07: Click at "My Account" button then Go to My account page. (in case bypass login page)		
		self.clickContShopORToAC(OS_sOrderSumTxt, OS_sTitleOrderRecipt, OS_sTitleHomepage); # OR08: Click at "Continue Shopping" then goto Homepage.
				
	end
	
	def teardown
		#@session.close_current_browser_session;
		assert_equal [], @verification_errors
	end	
	
	def throwException(modulename, txterror, functname)
		self.writeResult(modulename, functname, txterror, "Failed")
	end
  
end
