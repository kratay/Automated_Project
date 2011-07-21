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
	include Selenium::Client::Vendaqa::Search
	include Selenium::Client::Vendaqa::VCP
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
	
	##	vcpAtt = self.NewVCPWindowsAtt("kgvs9781845335151")
	##	puts vcpAtt

		#######################################ETA product ##############
		myParentWindows = @session.get_title
		updateVCP = self.UpdateVCPWindows("kwvsdq744a", "01/01/2000", 0, "12/12/2011")##(sSKU,dReleaseDate, iOnhand, dETADate)	
		vcp = self.NewVCPWindows("kwvsdq744a")
		aProduct = [vcp[0],vcp[1],vcp[3],vcp[4],vcp[5],vcp[6],'Out of Stock']
		@session.select_window myParentWindows
		self.searchResultVCP(aProduct[1])
		self.verifyVCP("ETA date in VCP",aProduct, "SR-09")# : case ETA date is less than current date and onhand <0")
		#######################################Pre order product ##############
		myParentWindows = @session.get_title
		updateVCP = self.UpdateVCPWindows("kwvsdq744a", "01/01/2012", 100, "")##(sSKU,dReleaseDate, iOnhand, dETADate)	
		vcp = self.NewVCPWindows("kwvsdq744a")
		aProduct = [vcp[0],vcp[1],vcp[3],vcp[4],vcp[5],vcp[6],'More Information']
		@session.select_window myParentWindows
		self.searchResultVCP(aProduct[1])
		self.verifyVCP("Pre Order date in VCP",aProduct, "SR-10")# : case ETA date is less than current date and onhand <0")
		#######################################Normal product ##############
		myParentWindows = @session.get_title
		updateVCP = self.UpdateVCPWindows("kwvsdq744a", "01/01/2000", 100, "")##(sSKU,dReleaseDate, iOnhand, dETADate)	
		vcp = self.NewVCPWindows("kwvsdq744a")		##vcp = [sSKU, sProdName, sProdDetail, dReleaseDate, iOnhand, dETADate, iPrice] 
		aProduct = [vcp[0],vcp[1],vcp[3],vcp[4],vcp[5],vcp[6],'More Information']
		@session.select_window myParentWindows

		self.searchResult

		self.verifyPagination
		if $gsBrowser == "*iexplore"
		puts "Inprogress for IE : sortByType"
		else 
			self.sortByType
		end
		self.searchResultVCP(aProduct[1])
		self.verifyVCP("Release date in VCP",aProduct, "SR-08")# : case release date is less than current date and onhand >0")
		##	self.addToBasket(aProduct) #-- No Quick Buy
		self.writeResult("SR-END" , "Finsished to execute", "Done", "Finished")
		
			
	    begin
	        assert self.is_text_present("ERROR::")
	    rescue #Test::Unit::AssertionFailedError
	        @verification_errors << $!
	    end				
	end
  
end
