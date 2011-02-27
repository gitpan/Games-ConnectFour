package Games::ConnectFour;
our $VERSION = 0.02;
use strict;
use warnings;
if($^O eq "MSWin32") {
	system "color 07";
	require Win32::Console::ANSI;
}

our %c = (
	d => "\e[0;37;40m",
	b => "\e[1;34;40m",
	0 => "\e[1;31;40m",
	1 => "\e[1;33;40m",
	w0 => "\e[0;30;41m",
	w1 => "\e[0;30;43m",

	save    => "\e[s",
	restore => "\e[u",
	clear   => "\e[0J",
);

sub input {
	my ($message, $default, @accepted) = @_;
	print $message;
	while(1) {
		(my $in = <STDIN>) =~ s/^\s+|\s+$//g;
		return $in if grep $in eq $_, @accepted;
		return $default if $in eq "" and defined $default;
		print "$c{d}Please input one of the following: ", join(", ", @accepted), ". ";
	}
}

sub init {
	print "\n$c{d}Welcome to Connect Four!\n";
	print "Set your console's background to black for best results.\n" if $^O ne "MSWin32";
	print "Exit at any time with a Control-C or equivalent.\n\n";
	while(1) {
		my $connect = input("How many do you want to connect (3, [4], 5, 6)? ", 4, 3..6);
		my ($w, $h) = @{(
			[7, 6],
			[8, 7],
			[9, 7],
			[10, 7],
		)[
		input("What size board do you want ([1], 2, 3, 4)? ", 1, 1..4) - 1]};
		my $turn = 0;
		my @board = (
			map [(" ") x $w], 1..$h
		);
		print "\n$c{b}";
		print "|", join("|", @$_), "|\n" for @board;
		print "-" x ($w * 2 + 1), "\n";
		print " ", join(" ", 1..$w), "\n\n\n\e[1A";
		while(1) {
			print "$c{$turn}Player " . ($turn + 1) . ", choose a column: $c{save}";
			my $in;
			while(1) {
				($in = <STDIN>) =~ s/^\s+|\s+$//g;
				print "$c{restore}$c{clear}";
				if(grep $in eq $_, 1..$w and $board[0][$in-1] eq " ") {
					$in--;
					last;
				}
				else {
					#play error sound
				}
			}
			my $up = $h + 4 . "A";
			my $right = 1 + $in * 2 . "C";
			print "\r\e[$up\e[$right";
			my $row = -1;
			do {
				if(fork) {
					$row++;
					select undef, undef, undef, 0.04;
					wait;
				}
				else {
					print " \b";
					print "\e[1B";
					print "o\b";
					exit;
				}
			} while $row + 1 < $h and $board[$row+1][$in] eq " ";
			$board[$row][$in] = $turn;
			print "$c{restore}\r";
			my @all;
			for([1, 0], [0, 1], [1, 1], [-1, 1]) {
				my ($xdir, $ydir) = @$_;
				my @mine = [$in, $row];
				for(1, -1) {
					my ($x, $y) = ($in, $row);
					while(
						($x -= $xdir * $_) >= 0 and $x < $w and
						($y -= $ydir * $_) >= 0 and $y < $h and
						$board[$y][$x] eq $turn
					) {
						push @mine, [$x, $y];
					}
				}
				push @all, @mine if @mine >= $connect;
			}
			if(@all) {
				for(@all) {
					my ($x, $y) = @$_;
					my $up = $h - $y + 3 . "A";
					my $right = 1 + $x * 2 . "C";
					print "\e[$up\e[$right";
					print "$c{'w'.$turn}o$c{restore}\r";
				}
				print "$c{$turn}Player " . ($turn + 1) . " wins!$c{clear}\n\n";
				print $c{d};
				last;
			}
			if(not grep $_ eq " ", map @$_, @board) {
				print "$c{d}The game is a tie!$c{clear}\n\n";
				last;
			}
			$turn = (0, 1)[$turn-1];
		}
	}
}
