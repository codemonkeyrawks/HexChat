######################## © 2012 Arcademan ###################################

use strict;
use warnings;
use vars qw(@ban_nick);
use vars qw(@ban_nick_data);
my $conf_file = HexChat::get_info('configdir') .'/banlist.conf'; # Filename banlist.conf

Xchat::register("Kick Control", "2.0", "Kick + Ban Control","");
Xchat::print('Type: /timeout <timeout> <channel> <nick> <hostmask> <seconds>, /kick <kick> <channel> <nick> <hostmask> <seconds>, /remove <Removes FSB>');
Xchat::print('When Closing and Restarting XChat you must unban the nick manually. Timers do not set on restart! Only for that session they remain.');

Xchat::hook_print("Connected", \&BanList);
sub BanList {
    if (-e $conf_file) { Xchat::command("echo - Use </removeban> if there is any exteneded bans after closing xchat. They also can be found in $conf_file."); #UnBan Nick!
      } else {
	open FILE, ">$conf_file";              # Write the File if Non-Existant
	close FILE;                            # Close File.
	}

#############################################################################

Xchat::hook_command("removeban", \&removeban);
sub removeban {
    open FILE, "<$conf_file";              # Reads banlist.conf
    @ban_nick_data = <FILE>;               # Bring banlist.conf in.
    close FILE;                            # Close File
}


my @ban_list = split(/[|]\s*/, $ban_nick_data[0] );

foreach (@ban_list) {
 
   my $chan = $ban_list[0];             # Read Data: Ban-List Host
   my $host = $ban_list[1];             # Read Data: Ban-List Channel 
   Xchat::command('mode -b ~q:*!*@' .$host); #UnBan Nick!
   Xchat::command('mode -b ~n:*!*@' .$host); #UnBan Nick!
   Xchat::command('mode ' . $chan . ' -b *!*@' . $host); #UnBan Nick!
   
   shift(@ban_list);                   # Shift Data: Ban List
   shift(@ban_list);                   # Shift Data: Ban List
   
}

open FILE, ">$conf_file";              # Reads banlist.conf
print FILE "";                         # Bring banlist.conf in.
close FILE;                            # Close File

}

#############################################################################

Xchat::hook_command("kick", \&kick);
sub kick {
  my $chan = $_[0][1];
  my $nick = $_[0][2];
  my $host = $_[0][3];
  my $tick = $_[0][4];
   if ($chan eq "") { Xchat::command("echo Use: <kick> <channel> <nick> <hostmask> <seconds>"); return Xchat::EAT_ALL; };
   if ($nick eq "") { Xchat::command("echo Use: <kick> <channel> <nick> <hostmask> <seconds>"); return Xchat::EAT_ALL; };
   if ($host eq "") { Xchat::command("echo Use: <kick> <channel> <nick> <hostmask> <seconds>"); return Xchat::EAT_ALL; };
   if ($tick eq "") { Xchat::command("echo Use: <kick> <channel> <nick> <hostmask> <seconds>"); return Xchat::EAT_ALL; };
   
   Xchat::command("me - $nick Your Attitude is Not Desired, You have been banned for $tick min kick."); #Message
   Xchat::command('mode ' . $chan . ' +b *!*@' . $host); #Ban Nick!
   Xchat::command("kick $nick"); #Kick Nick!
   
   push(@ban_nick,"$chan"); # Push Data: Ban-List
   push(@ban_nick,"$host"); # Push Data: Ban-List
   
   push(@ban_nick_data,"$chan|"); # Push Data: Ban-List (For File)
   push(@ban_nick_data,"$host|"); # Push Data: Ban-List (For File)
   
   open FILE, ">$conf_file";           # Writes banlist.conf
   print FILE @ban_nick_data;          # Print Content to banlist.conf
   close FILE;                         # Close File
   
    if ($tick eq 5) { Xchat::command("timer -refnum 1 -repeat 1 300 remove"); return Xchat::EAT_ALL };     #Sets 5 Min Timer.
	if ($tick eq 15) { Xchat::command("timer -refnum 1 -repeat 1 900 remove"); return Xchat::EAT_ALL };   #Sets 15 Min Timer.
	if ($tick eq 30) { Xchat::command("timer -refnum 1 -repeat 1 1800 remove"); return Xchat::EAT_ALL };   #Sets 30 Min Timer.
	if ($tick eq 60) { Xchat::command("timer -refnum 1 -repeat 1 3600 remove"); return Xchat::EAT_ALL };   #Sets 60 Min Timer.
	if ($tick eq 120) { Xchat::command("timer -refnum 1 -repeat 1 7200 remove"); return Xchat::EAT_ALL }; #Sets 120 Min Timer.
	if ($tick eq 180) { Xchat::command("timer -refnum 1 -repeat 1 10800 remove"); return Xchat::EAT_ALL }; #Sets 180 Min Timer.
	if ($tick eq 240) { Xchat::command("timer -refnum 1 -repeat 1 14400 remove"); return Xchat::EAT_ALL }; #Sets 240 Min Timer.
	
	Xchat::command("echo Use: <kick> <channel> <nick> <hostmask> <seconds>, Seconds = 5,15,30,60,120,180,240");
	
return Xchat::EAT_ALL;
}

Xchat::hook_command("timeout", \&timeout);
sub timeout {
  my $chan = $_[0][1];
  my $nick = $_[0][2];
  my $host = $_[0][3];
  my $tick = $_[0][4];
   if ($chan eq "") { Xchat::command("echo Use: <timeout> <channel> <nick> <hostmask> <seconds>"); return Xchat::EAT_ALL; };
   if ($nick eq "") { Xchat::command("echo Use: <timeout> <channel> <nick> <hostmask> <seconds>"); return Xchat::EAT_ALL; };
   if ($tick eq "") { Xchat::command("echo Use: <timeout> <channel> <nick> <hostmask> <seconds>"); return Xchat::EAT_ALL; };
   if ($host eq "") { Xchat::command("echo Use: <timeout> <channel> <nick> <hostmask> <seconds>"); return Xchat::EAT_ALL; };
   
   Xchat::command("me - $nick You Need To Take a Timeout, You have been set for $tick min silence."); #Message
   Xchat::command('mode +b ~q:*!*@' .$host);
   Xchat::command('mode +b ~n:*!*@' .$host);
   
   push(@ban_nick,"$chan"); # Push Data: Ban-List
   push(@ban_nick,"$host"); # Push Data: Ban-List
   
   push(@ban_nick_data,"$chan|"); # Push Data: Ban-List (For File)
   push(@ban_nick_data,"$host|"); # Push Data: Ban-List (For File)
   
   open FILE, ">$conf_file";           # Writes banlist.conf
   print FILE @ban_nick_data;          # Print Content to banlist.conf
   close FILE;                         # Close File
   
    if ($tick eq 5) { Xchat::command("timer -refnum 1 -repeat 1 300 remove"); return Xchat::EAT_ALL };     #Sets 5 Min Timer.
	if ($tick eq 15) { Xchat::command("timer -refnum 1 -repeat 1 900 remove"); return Xchat::EAT_ALL };   #Sets 15 Min Timer.
	if ($tick eq 30) { Xchat::command("timer -refnum 1 -repeat 1 1800 remove"); return Xchat::EAT_ALL };   #Sets 30 Min Timer.
	if ($tick eq 60) { Xchat::command("timer -refnum 1 -repeat 1 3600 remove"); return Xchat::EAT_ALL };   #Sets 60 Min Timer.
	if ($tick eq 120) { Xchat::command("timer -refnum 1 -repeat 1 7200 remove"); return Xchat::EAT_ALL }; #Sets 120 Min Timer.
	if ($tick eq 180) { Xchat::command("timer -refnum 1 -repeat 1 10800 remove"); return Xchat::EAT_ALL }; #Sets 180 Min Timer.
	if ($tick eq 240) { Xchat::command("timer -refnum 1 -repeat 1 14400 remove"); return Xchat::EAT_ALL }; #Sets 240 Min Timer.
	
	Xchat::command("echo Use: <timeout> <channel> <nick> <hostmask> <seconds>, Seconds = 5,15,30,60,120,180,240");
	
return Xchat::EAT_ALL;
}

Xchat::hook_command("remove", \&remove);
sub remove {
   my $chan = $ban_nick[0];             # Read Data: Ban-List Host
   my $host = $ban_nick[1];             # Read Data: Ban-List Channel    
   Xchat::command('mode -b ~q:*!*@' .$host); #UnBan Nick!
   Xchat::command('mode -b ~n:*!*@' .$host); #UnBan Nick!
   Xchat::command('mode ' . $chan . ' -b *!*@' . $host); #UnBan Nick!
   shift(@ban_nick);                        # Shift Data: Ban List
   shift(@ban_nick);                        # Shift Data: Ban List
   
   shift(@ban_nick_data);                   # Shift Data: Ban List
   shift(@ban_nick_data);                   # Shift Data: Ban List
   
   open FILE, ">$conf_file";           # Writes banlist.conf
   print FILE @ban_nick_data;          # Print Content to banlist.conf
   close FILE;                         # Close File
return Xchat::EAT_ALL;
}
