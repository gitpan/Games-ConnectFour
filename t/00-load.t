#!perl
use strict;
use warnings;
use Test::More;

use_ok('Games::ConnectFour');
can_ok('Games::ConnectFour', 'init');

# isnt($Games::Ponge::G{dir}, undef, 'Have a sharedir');

my $kidpid = fork;
if(!defined $kidpid or $kidpid) {
	isnt( $kidpid, undef, "We can fork" );
}
else {
	exit;
}

diag( "Testing ConnectFour $Games::ConnectFour::VERSION, Perl $], $^X" );

done_testing;
