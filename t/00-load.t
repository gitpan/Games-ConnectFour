#!perl
use strict;
use warnings;
use Test::More;

use_ok('Games::ConnectFour');
can_ok('Games::ConnectFour', 'init');

# isnt($Games::Ponge::G{dir}, undef, 'Have a sharedir');

diag( "Testing ConnectFour $Games::ConnectFour::VERSION, Perl $], $^X" );

done_testing;
