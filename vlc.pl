############ VLC Player 2.2 - © 2011, Arcademan. ############################
#!/usr/bin/perl
 
use strict;
use warnings;
use LWP::UserAgent;
use vars qw($lastsong);
use vars qw($hook);
 
#############################################################################
 
my $version = "2.0";
Xchat::register("VLC API", $version, "Displays VLC Player Info!","");
IRC::print('Loaded - VLC API - Use: /vlc or /mvlc :: Setup: Open VLC > View -> Add interface -> http interface :: Commands: /vlc = Show Output Bot Style, /mvlc = Manually do Command, /rvlc = Remove Timer /tvlc = Change Timer');
 
####################### Change Info Here: ###################################
 
# Leave empty for all channels and networks
my $validNetworks = "Geekshed";
my $validChannels = "#bots";

my $text      = "44";     # Text Color
my $lastsong  = "NULL";   # Last Song Text
my $tick      = "150000"; # Timer Control
my @song      = "NULL";   # Text to Set!

#############################################################################
 
foreach ("Channel Message", "Channel Message Hilight") { Xchat::hook_print($_, \&BotVLC, {"data" => [$_]}); }
sub BotVLC {
	my $strMsg = Xchat::strip_code($_[0][1]);
	if ($strMsg !~ m/^[@!`]play/i) { return Xchat::EAT_NONE; }
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
    &vlc;
	if ($bEmitted) { return Xchat::EAT_XCHAT; }
	return Xchat::EAT_NONE;
}

#############################################################################

Xchat::hook_command("vlc", \&vlc);
sub vlc {
 
my $browser  = LWP::UserAgent->new;                         # Create A session!
my $url      = 'http://127.0.0.1:8080/requests/status.xml'; # XML File Here!
$browser->timeout(3);                                       # How Long to Wait!
$browser->env_proxy;                                        # Proxy Mode!
my $response = $browser->get($url);                         # Get Info!
 
#Report Back if its Wrong!
if ( !$response->is_success ) { 
Xchat::command("echo - Could Not Get: $url . Open VLC > View -> Add interface -> http interface"); return Xchat::EAT_NONE;
}
 
#Report Back if its Right!
if ( $response->is_success ) { 
 
# Get Results into Variable!
my @source = $response->content;
 
# Split the Content Down!
my @songsplit = split(/  \s*/,$response->content);
my $songname  = $songsplit[8];

while ($songname =~ m/\<info name='(?:artist|title)'>([^<]+)<\/info>/gi) {
push(@song,"$1");
}
 
if ( $lastsong ne $songname ) {
Xchat::command("me \003$text- \0034Now Playing: \0033\0036 Song: $song[2] - Artist: $song[1] \003");
$lastsong = $songname; return Xchat::EAT_ALL; }
 
if ( $lastsong = $songname ) { return Xchat::EAT_ALL; }

}
}

#############################################################################

Xchat::hook_command("mvlc", \&mvlc);
sub mvlc {
 
my $browser  = LWP::UserAgent->new;                         # Create A session!
my $url      = 'http://127.0.0.1:8080/requests/status.xml'; # XML File Here!
$browser->timeout(3);                                       # How Long to Wait!
$browser->env_proxy;                                        # Proxy Mode!
my $response = $browser->get($url);                         # Get Info!
 
#Report Back if its Wrong!
if ( !$response->is_success ) { 
Xchat::command("echo - Could Not Get: $url . Open VLC > View -> Add interface -> http interface"); return Xchat::EAT_NONE;
}
 
#Report Back if its Right!
if ( $response->is_success ) { 
 
# Get Results into Variable!
my @source = $response->content;
 
# Split the Content Down!
my @songsplit = split(/  \s*/,$response->content);
my $songname  = $songsplit[8];

while ($songname =~ m/\<info name='(?:artist|title)'>([^<]+)<\/info>/gi) {
push(@song,"$1");
}

Xchat::command("me \003$text- \0034Now Playing: \0033\0036 Song: $song[2] - Artist: $song[1] \003");

}
}
 
#############################################################################
 
Xchat::hook_command("rvlc", \&rvlc); 
sub rvlc {
Xchat::unhook( $hook ); # Remove Timer
Xchat::command("echo - Timer Removed!");
return Xchat::EAT_ALL;
}
 
#############################################################################
 
Xchat::hook_command("tvlc", \&tvlc); 
sub tvlc {
$hook = Xchat::hook_timer( $tick, \&vlc); # Start Timer
Xchat::command("echo - Timer Set to $tick seconds.");
return Xchat::EAT_ALL;
}
 
#############################################################################
