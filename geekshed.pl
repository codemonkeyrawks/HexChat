######################## © 2012 Arcademan ###################################

use strict;
use warnings;
use vars qw($nick);

#############################################################################

Xchat::register("Geekshed", "2.0", "Geekshed Management Script","");
Xchat::print('Type: /founder <founder <nick>, /permxop <permxop> <channel> <nick> <access>, /permacc <permacc> <channel> <nick> <access>, /silence <silence> <hostname>, /silenceban <silenceban> <hostname>');

#############################################################################

Xchat::hook_command("founder", \&founder);
sub founder {
  my $chan = $_[0][1];
  my $nick = $_[0][2];
   if ($chan eq "") { Xchat::command("echo Use: <founder> <channel> <nick>"); return Xchat::EAT_ALL; };
   if ($nick eq "") { Xchat::command("echo Use: <founder> <channel> <nick>"); return Xchat::EAT_ALL; };
    Xchat::command("cs SET $chan XOP OFF");
	Xchat::command("cs ACCESS $chan ADD $nick 9999");
	Xchat::command("echo $nick has been set as founder of $chan . They must now cycle it and rejoin it. XOP has been turned OFF! This means that you must now use the access system. For help doing this, visit http://www.geekshed.net/2009/12/access-system-tutorial/");
return Xchat::EAT_ALL;
}

Xchat::hook_command("permxop", \&permxop);
sub permxop {
  my $chan = $_[0][1];
  my $nick = $_[0][2];
  my $access = $_[0][3];
   if ($chan eq "") { Xchat::command("echo Use: <permxop> <channel> <nick> <access>"); return Xchat::EAT_ALL; };
   if ($nick eq "") { Xchat::command("echo Use: <permxop> <channel> <nick> <access>"); return Xchat::EAT_ALL; };
   if ($access eq "") { Xchat::command("echo Use: <permxop> <channel> <nick> <access>"); return Xchat::EAT_ALL; };
    Xchat::command("cs $access $chan add $nick");
	Xchat::command("cs sync $chan");
	Xchat::command("echo Set $nick to $access on $chan.");
return Xchat::EAT_ALL;
}

Xchat::hook_command("permacc", "permacc");
sub permacc {
  my $chan = $_[0][1];
  my $nick = $_[0][2];
  my $access = $_[0][3];
   if ($chan eq "") { Xchat::command("echo Use: <permacc> <channel> <nick> <access>"); return Xchat::EAT_ALL; };
   if ($nick eq "") { Xchat::command("echo Use: <permacc> <channel> <nick> <access>"); return Xchat::EAT_ALL; };
   if ($access eq "") { Xchat::command("echo Use: <permacc> <channel> <nick> <access>"); return Xchat::EAT_ALL; };
    Xchat::command("cs $access $chan add $nick $access");
	Xchat::command("cs sync $chan");
	Xchat::command("echo Set $nick to $access on $chan.");
return Xchat::EAT_ALL;
}

Xchat::hook_command("silence", \&silence);
sub silence {
  my $nick = $_[0][1];
   if ($nick eq "") { Xchat::command("echo Use: <silence> <hostname>"); return Xchat::EAT_ALL; };
    Xchat::command('mode +b ~q:*!*@' .$nick);
	Xchat::command("me - You have been silenced!");
return Xchat::EAT_ALL;
}

Xchat::hook_command("silenceban", \&silenceban);
sub silenceban {
  my $nick = $_[0][1];
   if ($nick eq "") { Xchat::command("echo Use: <silenceban> <hostname>"); return Xchat::EAT_ALL; };
    Xchat::command('mode +b ~q:*!*@' .$nick);
	Xchat::command('mode +b ~n:*!*@' .$nick);
	Xchat::command("me - You have been silenced!");
return Xchat::EAT_ALL;
}
