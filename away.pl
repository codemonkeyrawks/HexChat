############ Away API 2.0 - © 2011, Arcademan. ##############################
#!/usr/bin/perl
 
use strict; 
use warnings;
use Xchat qw( :all );
 
#############################################################################

Xchat::register("Auto Away Messeger", "2.0", "Displays Auto-Away Message.","");  
Xchat::print('Type: /away-serv <away on network>, /away-serv-off <not away on network> /away <away>, /back <away off> /away-msg <message>');
 
#############################################################################
 
Xchat::hook_command("away-serv", \&away_serv); 
sub away_serv{
        my $message = $_[0][1];
		 if ((!(defined($message))) || ($message eq "")) {
		  Xchat::command("echo Use: /away-serv <Message>");
		return Xchat::EAT_ALL;
	}
        my @status = "ON"; 
        my @away =  Xchat::get_info( "away" ); 
        my $info = (Xchat::context_info->{flags} );
 if ($info == 3721) { Xchat::command("echo Away: --( @status )--");Xchat::command("allserv away $message"); }
 if ($info == 3725) { Xchat::command("echo Away: --( @away )--"); }
        return Xchat::EAT_ALL;
}

Xchat::hook_command("away-serv-off", \&away_serv_off);
sub away_serv_off{
        my @status = "OFF";
         Xchat::command("echo Away: --( @status )--");Xchat::command("allserv back");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("away", \&away_on);
sub away_on{
        my $message = $_[0][1];
		 if ((!(defined($message))) || ($message eq "")) {
		  Xchat::command("echo Use: /away <Message>");
		return Xchat::EAT_ALL;
	}
        my @status = "ON"; 
        my @away =  Xchat::get_info( "away" ); 
        my $info = (Xchat::context_info->{flags} );
 if ($info == 3721) { Xchat::command("echo Away: --( @status )--");Xchat::command("away $message"); }
 if ($info == 3725) { Xchat::command("echo Away: --( @away )--"); }
        return Xchat::EAT_ALL;
}

Xchat::hook_command("back", \&away_off);
sub away_off{
        my @status = "OFF";
         Xchat::command("echo Away: --( @status )--");Xchat::command("back");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("away-msg", \&away_msg);
sub away_msg{
        my @away =  Xchat::get_info( "away" ); 
         Xchat::command("echo Away: @away ");
        return Xchat::EAT_ALL;
}

Xchat::hook_command("away-help", \&away_help);
sub away_help{
         Xchat::command("echo Type: /away-serv <away on network>, /away-serv-off <not away on network> /away <away>, /back <away off> /away-msg <message>");
        return Xchat::EAT_ALL;
}
