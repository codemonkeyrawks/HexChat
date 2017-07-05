############ Air1.com API 2.0 - © 2011, Arcademan. ###########################
#!/usr/bin/perl
 
use strict;
use warnings;
use LWP::UserAgent;
 
#############################################################################
 
my $version = "1.0";
Xchat::register("Air1 API", $version, "Display's Air1 Music via IRC!","");
IRC::print('Loaded - Use: /air1 <Displays Air 1 Info!');
 
#############################################################################
 
my $text      = "44"; #desired text color
my @song      = "NULL";   # Text to Set!
my @song2     = "NULL";   # Text to Set!
my @song3     = "NULL";   # Text to Set!
 
#############################################################################
 
Xchat::hook_command("air1", \&air1);
 
sub air1 {
 
my $browser  = LWP::UserAgent->new;                          # Create A session
my $url      = 'http://objects.air1.com/RSS/NowPlaying.aspx?s=2';   # Change Recent Track Info Here!
$browser->timeout(3);                                        # How Long to Wait!
$browser->env_proxy;                                         # Proxy Mode! 
my $response = $browser->get($url);                          # Get Info!
  
#Report Back if its Wrong!
if ( !$response->is_success ) { 
Xchat::command("echo - Could Not Get: $url . Try Again Later.");
}
 
#Report Back if its Right!
if ( $response->is_success ) { 
 
# Split the Content Down!
my @songsplit = split(/  \s*/,$response->content);
my $songname  = $songsplit[0];

while ($songname =~ m/<title\>([^<]+)<\/title>/gi) {
unshift(@song,"$1");
}

while ($songname =~ m/<songInfo:artist>([^<]+)<\/songInfo:artist>/gi) {
unshift(@song2,"$1");
}

while ($songname =~ m/<songInfo:album>([^<]+)<\/songInfo:album>/gi) {
unshift(@song3,"$1");
}

Xchat::command("me \003$text-\0039 Air 1 Radio:\0035\0036 Song: $song[4] - Artist: $song2[4] - Album: $song3[4] @ http://www.air1.com \0035\003");
 
 return Xchat::EAT_ALL;
}
}
 
#############################################################################
