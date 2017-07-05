############ Time + Date API 2.0 - © 2011, Arcademan. ######################
#!/usr/bin/perl

use strict; 
use warnings;
use Xchat qw( :all );
use POSIX;
use vars qw($millitary);

$millitary = 1; # 0 = Millitary , 1 = 12 Hr.

#############################################################################
 
Xchat::register("Clock and Date", "3.0", "Displays Clock and Date.","");
Xchat::print('Type: /time <shows time>, /date <shows date>');

#############################################################################
 
Xchat::hook_command("time", \&time); 
sub time {
        if ($millitary eq 0) { Xchat::command("echo - \0032Time:\0035 ~\0033 " . strftime('%H:%M:%S', localtime) . "\0035 ~"); }
        else { Xchat::command("echo - \0032Time:\0035 ~\0033 " . strftime('%I:%M:%S %p', localtime) . "\0035 ~"); }
        return Xchat::EAT_ALL;
}
 
Xchat::hook_command("date", \&date);
sub date {
        Xchat::command("me - \0032Date:\0035 ~\0033 " . strftime('%x', localtime) . "\0035 ~");
		return Xchat::EAT_ALL;
}

Xchat::hook_command("time-date", \&time_date);
sub time_date {
        if ($millitary eq 0) { Xchat::command("echo - \0032Time:\0035 ~\0033 " . strftime('%H:%M:%S', localtime) . "\0035 ~ \0032Date:\0035 ~\0033 " . strftime('%x', localtime) . "\0035 ~"); }
        else { Xchat::command("echo - \0032Time:\0035 ~\0033 " . strftime('%I:%M:%S %p', localtime) . "\0035 ~ \0032Date:\0035 ~\0033 " . strftime('%x', localtime) . "\0035 ~"); }
        return Xchat::EAT_ALL;
}

Xchat::hook_command("tdhelp", \&tdhelp);
sub tdhelp {
        Xchat::command("echo - Type: /time <shows time>, /date <shows date>");
        return Xchat::EAT_ALL;
}
