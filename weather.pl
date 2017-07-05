######################## © 2012 Arcademan ###################################
#!/usr/bin/perl
 
use strict;
use warnings;
use LWP::UserAgent;
use vars qw(@storezipcode);
use vars qw($hook);
 
#############################################################################
 
my $text          = "44"; #desired text color
my $defaultzip    = "83634";
 
# Leave empty for all channels and networks
my $validNetworks = "Geekshed";
my $validChannels = "#Bots";

$storezipcode[0] = "";
$storezipcode[1] = "";
$storezipcode[2] = "";
$storezipcode[3] = "";
$storezipcode[4] = "";
$storezipcode[5] = "";
 
#############################################################################
 
my $version = "2.5";
Xchat::register("Forecast", $version, "Displays the forecast!","");
Xchat::print('Loaded - Forecast - Usage: /forecast <5 digit zip> (' . $defaultzip . ' is default)');
 
#############################################################################

Xchat::hook_command("removezip", \&removezip); 
sub removezip {
 shift(@storezipcode);   # Shift Data Out
 Xchat::unhook( $hook ); # Remove Timer
 return Xchat::EAT_ALL;
}
 
#############################################################################
 
Xchat::hook_command("forecast", \&forecast);
sub forecast {
	if ($_[1][0] =~ m/\b(\d{5})\b/i) { &forecastzip($+); }
	else { &forecastzip ($defaultzip); }
	return Xchat::EAT_ALL;
}

#############################################################################
 
foreach ("Channel Message", "Channel Message Hilight") { Xchat::hook_print($_, \&Botforecast, {"data" => [$_]}); }
sub Botforecast {
	my $strMsg = Xchat::strip_code($_[0][1]);
	if ($strMsg !~ m/^[@~`]forecast/i) { return Xchat::EAT_NONE; }
	if ($validChannels) {
		# Check Channel
		my $strChan = Xchat::get_info("channel");
		(my $TestChan = $validChannels) =~ s/,/|/g;
		if ($strChan !~ m/^(($TestChan))$/i) { return Xchat::EAT_NONE; }
	}
	if ($validNetworks) {
		# Check Network
		my $strNetwork = Xchat::get_info("network");
		(my $TestNet = $validNetworks) =~ s/,/|/g;
		if ($strNetwork !~ m/^(($TestNet))/i) { return Xchat::EAT_NONE; }
	}
	# Test for op or voice status in channel
	if ( (!defined($_[0][2])) || (index(reverse(Xchat::context_info->{nickprefixes}), $_[0][2]) < 0) ) { return Xchat::EAT_NONE; }
	my $bEmitted = Xchat::emit_print($_[1][0], $_[0][0], $_[0][1], $_[0][2]);
	if ($_[0][1] =~ m/\b(\d{5})\b/){ &forecastzip($+); }
	else { &forecastzip($defaultzip); }
	if ($bEmitted) { return Xchat::EAT_XCHAT; }
	return Xchat::EAT_NONE;
}
 
#############################################################################
 
sub forecastzip {
	my $zipcode = $_[0];                                           # Add Zipcode!
 
	my $browser  = LWP::UserAgent->new;                            # Create A session!
	my $url = 'http://www.wunderground.com/auto/raw/' . $zipcode;  # XML File Here!
	$browser->timeout(3);                                          # How Long to Wait!
	$browser->env_proxy;                                           # Proxy Mode!
	my $response = $browser->get($url);                            # Get Info!
 
	#Report Back if its Wrong!
	if ( !$response->is_success ) {
		Xchat::command("echo - Could Not Get: $url . Try Again Later.");
		return;
	}
	#Report Back if its Right!
	else {
		if ( !$response->content || $response->content =~ /<.+>/s ) {
			Xchat::command("me \003$text - Please Enter A Vaild Zipcode/City Again!");
			return;
		}
		
		if ($storezipcode[0] eq $zipcode) {	Xchat::command("me - Please Wait 5 Min Before Doing it Again."); return }
		
		unshift(@storezipcode,"$zipcode");

		if ($storezipcode[1] eq $zipcode) {	Xchat::command("me - Please Wait 5 Min Before Doing it Again."); return }
		if ($storezipcode[2] eq $zipcode) {	Xchat::command("me - Please Wait 5 Min Before Doing it Again."); return }
		if ($storezipcode[3] eq $zipcode) {	Xchat::command("me - Please Wait 5 Min Before Doing it Again."); return }
		if ($storezipcode[4] eq $zipcode) {	Xchat::command("me - Please Wait 5 Min Before Doing it Again."); return }
		if ($storezipcode[5] eq $zipcode) {	Xchat::command("me - Please Wait 5 Min Before Doing it Again."); return }
		
		my @weather = split(/[|]\s*/, $response->content);
		####### Find what you want to print here ########
		my %forecast = ("timezone", $weather[0], "temp", $weather[1], "null", $weather[2], "null2", $weather[3], "humidity", $weather[4], "dewpoint", $weather[5], "windspeed", $weather[6], "barometer", $weather[7], "cloudcover", $weather[8], "visibility", $weather[9], "yestlow", $weather[13], "yesthigh", $weather[14], "city", $weather[18], "state", $weather[19], "update", $weather[20], "lastupdate", $weather[21], "stationid", $weather[22], "uvindex", $weather[23]);
 
		Xchat::command("me \003$text ~ \00313 Y{Low}: $forecast{yestlow} °F \0032 ˜ \00314 Y{High}: $forecast{yesthigh} °F \0032 ˜ \00313 Temp  $forecast{temp} °F \0032 ˜ \0033 Humidity: $forecast{humidity} \0032 ˜ \0034 DewPoint: $forecast{dewpoint} % \0032 ˜ \0035 WindSpeed: $forecast{windspeed} \0032 ˜ \0036 Barometer: $forecast{barometer} % \0032 ˜ \0037 $forecast{cloudcover} \0032 ˜ \0038 Visibility $forecast{visibility} \0032 ˜ \0039 $forecast{city} , $forecast{state} \0032 ˜ \00310 Station: $forecast{stationid} \0032 ˜ \00311 UV: $forecast{uvindex} \0032 ˜ \00311 Last Update: $forecast{lastupdate} \0032 ˜ \00312 Source: $forecast{update} \003$text ~ \003");
	
	    $hook = Xchat::hook_timer( 300000 , \&removezip); # Wait 5 Min.
		
		}
	
}
