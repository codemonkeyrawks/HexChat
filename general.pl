#############################################################################
#!/usr/bin/perl
 
use strict; 
use warnings;
use Xchat qw( :all );
my $count = 0;
 
#############################################################################
my $version = "1.0";
Xchat::register("General Info", $version, "Displays CPU & ect.",""); 
Xchat::print('Type: /version <shows version>,  /host <shows hostname>, /network <shows network>, /server <shows server>, /topic <shows topic>, /channel <shows channel>, / hug nick <hugs nick>, /huggle nick <huggles nick> , /snuggle nick <snuggles nick>, /hugs <hugs everyone>, /huggles <huggles everyone>, /snuggles <snuggles everyone>, /lag <lagtime>, /users <users>');
 
#############################################################################

Xchat::hook_command("hug", \&hug); 
sub hug {
        my $nick = $_[0][1];
        Xchat::command("me hugs --( $nick )--");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("huggle", \&huggle); 
sub huggle {
        my $nick = $_[0][1];
        Xchat::command("me huggles --( $nick )--");
        return Xchat::EAT_ALL;
}
 
Xchat::hook_command("snuggle", \&snuggle); 
sub snuggle {
        my $nick = $_[0][1];
        Xchat::command("me snuggles --( $nick )--");
        return Xchat::EAT_ALL;
}
 
#############################################################################
 
my $everyone = 'everyone';
 
Xchat::hook_command("hugs", \&hugs); 
sub hugs {
        Xchat::command("me hugs --( $everyone )--");
        return Xchat::EAT_ALL;
}
 
Xchat::hook_command("huggles", \&huggles);
sub huggles {
        Xchat::command("me huggles --( $everyone )--");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("snuggles", \&snuggles); 
sub snuggles {
        Xchat::command("me snuggles --( $everyone )--");
        return Xchat::EAT_ALL;
}
 
#############################################################################

Xchat::hook_command("version", \&version);
sub version {
        my $version = Xchat::get_info ( "version" );
        Xchat::command("me - X-Chat Version: $version");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("host", \&host);  
sub host {
        my $host = Xchat::get_info ( "host" );
        Xchat::command("me is on - Hostname: $host");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("network", \&network);
sub network {
        my $network = Xchat::get_info ( "network" );
        Xchat::command("me is on - Network: $network");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("server", \&server);
sub server {
        my $server = Xchat::get_info ( "server" );
        Xchat::command("me is on - Server: $server");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("topic", \&topic);   
sub topic {
        my $topic = Xchat::get_info ( "topic" );
        Xchat::command("me - $topic");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("channel", \&channel);
sub channel {
        my $channel = Xchat::get_info ( "channel" );
        Xchat::command("me is on - Channel: $channel");
        return Xchat::EAT_ALL;
}
 
#############################################################################

Xchat::hook_command("insult", \&insult);  
sub insult {
        Xchat::command("say !insult");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("lag", \&lag);
sub lag{
        Xchat::command(prnt "Lag - " . context_info()->{lag} . "mS");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("users", \&users); 
sub users{
        Xchat::command(prnt "There are " . context_info()->{users} . " users in this channel.");
        return Xchat::EAT_ALL;
}
