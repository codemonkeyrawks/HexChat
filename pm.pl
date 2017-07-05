############ PM Blocker 2.3 - © 2011, Arcademan. ############################
#!/usr/bin/perl
 
use strict;
use warnings;
use vars qw(@PM_Block);
 
##########  Configuration  ##################################################
 
my $conf_file_2 = HexChat::get_info('configdir') .'/pmblock.conf'; # Filename pmblock.conf
my $block = 1; # 0 = Block All, Except User List Defined in pmblock.conf, 1 = Block only people listed in pmblock.conf
 
#############################################################################
 
Xchat::register("PM Blocker", "2.3", "PM Blocking.");
Xchat::print('Type: /pm <nick> = Adds Nick to PM Block List. , /removepm = Removes Last Nick From PM Block List. ');
 
#############################################################################
 
Xchat::hook_print("Connected", \&PMBlock);
sub PMBlock {
    if (-e $conf_file_2) {
	open FILE, "<$conf_file_2";            # Reads pmblock.conf  
	@PM_Block = <FILE>;                    # Bring pmblock.conf in.
	close FILE;                            # Close File
	  } else {
	open FILE, ">$conf_file_2";            # Write the File if Non-Existant
	close FILE;                            # Close File
	}
}
 
#############################################################################
 
Xchat::hook_server( "PRIVMSG", \&PMSG, Xchat::PRI_HIGHEST );
sub PMSG {
	my $strme = Xchat::get_info("nick");
	if ($_[1][0] !~ m/^:([^!]+)!([^@]+)@(\S+)\sPRIVMSG\s($strme)\s:/) { return Xchat::EAT_NONE; } # Not a PM for me
	my $strNick = $1; my $strIdent = $2; my $strHost = $3;
	my $foundnick = 0;
	foreach (@PM_Block) { # Check each item $_ in the block list
		if ($strNick eq $_) { # Found the nick in our list
			$foundnick = 1;
			last;
		}
	}
	if ($block == $foundnick) { # Block the PM if blocking and found, or not blocking and not found
		Xchat::command("msg $strNick Your PM was blocked!");
		return Xchat::EAT_ALL;
	} else {
		return Xchat::EAT_NONE;
	}
}
 
#############################################################################
 
Xchat::hook_command("pm", "pm");
sub pm {
	my $nick = $_[0][1]; # Get Nick

	if ((!(defined($nick))) || ($nick eq "")) {
		Xchat::command("echo Use: <pm> <nick>");
		return Xchat::EAT_ALL;
	}

	push(@PM_Block,"$nick"); # Push Data: PM-List
	open FILE, ">$conf_file_2";       # Writes pmblock.conf
	print FILE @PM_Block;             # Print Content to pmblock.txt
	close FILE;                       # Close File
   
	if ($block) {
		Xchat::command("echo @PM_Block will be blocked from future pm's, everyone else can pm.");
	} else {
		Xchat::command("echo @PM_Block will be allowed though, no one else.");
	}
	return Xchat::EAT_ALL;
}
 
#############################################################################
 
Xchat::hook_command("removepm", "removepm");
sub removepm {
	shift(@PM_Block);                  # Shift Data: PM List
	open FILE, ">$conf_file_2";        # Writes pmblock.conf
	print FILE @PM_Block;              # Print Content to pmblock.txt
	close FILE;                        # Close File
   
	Xchat::command("echo @PM_Block will be blocked from future pm's.");

	return Xchat::EAT_ALL;
}
 
#############################################################################
