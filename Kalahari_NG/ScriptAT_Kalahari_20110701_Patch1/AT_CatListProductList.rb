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
	include Selenium::Client::Vendaqa::CatListProductList
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
#		#self.selectRegion

		#******************** Product list********************#
		self.goToProductList
		self.verifyPagination
		self.goToProductList
	#	self.verifyVCP("Release date in VCP",$PL_aNormalProduct)# : case release date is less than current date and onhand >0")
	#	self.verifyVCP("ETA date in VCP",$PL_aETAProduct)# : case ETA date is less than current date and onhand <0")
	#	self.verifyVCP("Pre Order date in VCP",$PL_aPreOrderProduct)# : case release date is more than current date and onhand >0")
	#	self.addToBasket	#no qiuck link
			
	    begin
	        assert self.is_text_present("ERROR::")
	    rescue #Test::Unit::AssertionFailedError
	        @verification_errors << $!
	    end				
	end
  
end
