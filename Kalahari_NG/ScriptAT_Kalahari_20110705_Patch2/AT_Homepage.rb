require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "selenium/client/idiomatic"
require "selenium/client/vendaqa/info"
require "selenium/client/vendaqa/customer"
require "selenium/client/vendaqa/commons"



class Untitled <  Test::Unit::TestCase	  

	include Selenium::Client::Vendaqa::Commons
	include Selenium::Client::Vendaqa::Homepage
	def setup

		@verification_errors = []
		@session = Selenium::Client::Driver.new \
			:host => $gsHost,
			:port => $giPort,
			:browser => $gsBrowser,
			:url => $gsURL,
			:timeout_in_second => $giTimeOut
		@session.start_new_browser_session('commandLineFlags' => '--disable-web-security')	
		@session.open "/page/home"
		@session.wait_for_page_to_load
		@session.window_maximize
		
	end

	def teardown
			#@seleniumnew.closeBrowser
		assert_equal [], @verification_errors
	
	end

	def test_untitled
		#self.selectRegion

		#******************** Mini cart********************#

		if @session.element?($LoctMyacct)==true
			@session.click($loctGotoLogout)
		end
		self.checkoutEmptyMiniCart("HP-10")
		self.clickMinicartItem
		self.nologinAddBasket
		self.checkoutFromMiniCart("HP-11")
		self.loginAddBasket
		self.clickMinicartItem
		self.checkoutFromMiniCart("HP-12")

		#******************** Search********************#
		self.searchHomepage

		#******************** Newsletter Box ********************#
		self.newsletterBoxVerify("", "Blank email", false, "HP-15")
		self.newsletterBoxVerify("sssss", "Invalid email", false, "HP-16")
		self.newsletterBoxVerify("sssss@dd&.com", "Invalid email", false, "HP-16")
		self.newsletterBoxVerify("sssss@d.com#", "Invalid email", false, "HP-16")
		if $gsBrowser == "*iexplore"
		puts "Inprogress for IE : Enter registered email address and Enter new email address case (newsletterBoxVerify function)"
		else 
			self.newsletterBoxVerify($gsExistUser, "Enter registered email address", false, "HP-19, HP-20") #***** not work for IE***
			self.newsletterBoxVerify($HP_sNewEmail, "Enter new email address", true, "HP-17, HP-18")#***** not work for IE***
		end

		#******************** Gift Certificates ********************#
		self.GiftCertifications
		self.GiftCertificationsVerify("!", "!", "Enter invalid ", false, "HP-26")
		self.GiftCertificationsVerify("NameforGiftCert", "1500", "Enter valid ", true, "HP-27")	

	    begin
	        assert self.is_text_present("ERROR::")
	    rescue #Test::Unit::AssertionFailedError
	        @verification_errors << $!
	    end				
	end
  
end
