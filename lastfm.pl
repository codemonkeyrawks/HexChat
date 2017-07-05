############ Last-FM API 2.0 - © 2011, Arcademan. ###########################
#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use vars qw($fmset);

#############################################################################

my $version = "1.0";
Xchat::register("LastFM API", $version, "Displays LastFM Music via Rythembox!","");
IRC::print('Loaded - LastFM API via Rythembox - Use: /pl or /recent or /love or /loved & Change $fmset! or Do: /fmset <username>');

#############################################################################

my $text      = "44"; #desired text color
$fmset     = "codemonkeyrawks"; #Set Username

#############################################################################

Xchat::hook_command("fmset", \&fmset);
Xchat::hook_command("pl", \&player);
Xchat::hook_command("recent", \&recent);
Xchat::hook_command("love", \&love);
Xchat::hook_command("loved", \&loved);

#############################################################################

sub fmset {

$fmset = $_[0][1];
if ($fmset eq "") { Xchat::command("echo - Could Not Set. Try Again.") } ;
if (!$fmset eq "") { Xchat::command("echo - Last-FM: $fmset") } ;

}

#############################################################################

sub player {

my $browser  = LWP::UserAgent->new;                          # Create A session
my $url      = 'http://ws.audioscrobbler.com/1.0/user/' .$fmset . '/recenttracks.rss';   # Change Recent Track Info Here!
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
my $songname  = $songsplit[12];

$songname =~ m/<title>([^-–<]+)[-–]([^<]+)<\/title>/; my $artist = $1;
$songname =~ m/<title>([^-–<]+)[-–]([^<]+)<\/title>/; my $song = substr($2, 3);
Xchat::command("me \003$text-\0039 LastFM -\0035\0036 Artist: $artist - \0038 Song: $song \0035\003");

 return Xchat::EAT_ALL;
}
}

#############################################################################

sub recent {

my $browser  = LWP::UserAgent->new;                          # Create A session
my $url      = 'http://ws.audioscrobbler.com/1.0/user/' .$fmset . '/recenttracks.rss';   # Change Recent Track Info Here!
$browser->timeout(3);                                        # How Long to Wait!
$browser->env_proxy;                                         # Proxy Mode!
my $response = $browser->get($url);                          # Get Info!

#Report Back if its Wrong!
if ( !$response->is_success ) {
Xchat::command("echo - Could Not Get: $url . Try Again Later.");
}

#Report Back if its Right!
if ( $response->is_success ) {

# Split the Content Down! Recent = 10
my @songsplit = split(/  \s*/,$response->content);

# Define an array of our recent track titles
my @songname = ($songsplit[12],$songsplit[19],$songsplit[26],$songsplit[33],$songsplit[40],$songsplit[47],$songsplit[54],$songsplit[61],$songsplit[68],$songsplit[75]);

# Loop through our recent track titles to remove the <title> </title> tags
foreach (@songname) {
    $_ =~ m/title\>([^<]+)/i;
    $_ = $1;
}

Xchat::command("me \003$text - \0039 Recent: \0032 1: $songname[0] \0031 * \0033 2: $songname[1] \0031 * \0034 3: $songname[2] \0031 * \0035 4: $songname[3] \0031 * \0036 5: $songname[4] \0031 * \0037 6: $songname[5] \0031 * \0038 7: $songname[6] \0031 * \0039 8: $songname[7] \0031 * \00310 9: $songname[8] \0031 * \00311 10: $songname[9] \003");
return Xchat::EAT_ALL;

}
}

#############################################################################

sub love {

my $browser  = LWP::UserAgent->new;                          # Create A session
my $url      = 'http://ws.audioscrobbler.com/2.0/user/' . $fmset . '/lovedtracks.rss';   # Change Loved Track Info Here!
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
my $songname  = $songsplit[12];

$songname =~ m/title\>([^<]+)/i;

Xchat::command("me \003$text - \0039 Loved:\0035\0032 $1\0035 \003");
 return Xchat::EAT_ALL;
}
}

#############################################################################

sub loved {

my $browser  = LWP::UserAgent->new;                          # Create A session
my $url      = 'http://ws.audioscrobbler.com/2.0/user/' . $fmset . '/lovedtracks.rss';   # Change Loved Track Info Here!
$browser->timeout(3);                                        # How Long to Wait!
$browser->env_proxy;                                         # Proxy Mode!
my $response = $browser->get($url);                          # Get Info!

#Report Back if its Wrong!
if ( !$response->is_success ) {
Xchat::command("echo - Could Not Get: $url . Try Again Later.");
}

#Report Back if its Right!
if ( $response->is_success ) {

# Split the Content Down! Recent = 10
my @songsplit = split(/  \s*/,$response->content);

# Define an array of our recent track titles
my @songname = ($songsplit[12],$songsplit[19],$songsplit[26],$songsplit[33],$songsplit[40],$songsplit[47],$songsplit[54],$songsplit[61],$songsplit[68],$songsplit[75]);

# Loop through our recent track titles to remove the <title> </title> tags
foreach (@songname) {
    $_ =~ m/title\>([^<]+)/i;
    $_ = $1;
}

Xchat::command("me \003$text - \0039 Loved: \0032 1: $songname[0] \0031 * \0033 2: $songname[1] \0031 * \0034 3: $songname[2] \0031 * \0035 4: $songname[3] \0031 * \0036 5: $songname[4] \0031 * \0037 6: $songname[5] \0031 * \0038 7: $songname[6] \0031 * \0039 8: $songname[7] \0031 * \00310 9: $songname[8] \0031 * \00311 10: $songname[9] \003");
return Xchat::EAT_ALL
}
}

#############################################################################
