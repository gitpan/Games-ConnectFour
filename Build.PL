#!/usr/bin/env perl
use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
	module_name   => 'Games::ConnectFour',
	dist_abstract => 'A Connect Four game in ANSI',
	license       => 'perl',
	share_dir     => 'share',
	requires => {
		'perl'       => 5.006,
		'Test::More' => 0,
		$^O eq "MSWin32" ? (
		'Win32::Console::ANSI' => 1.04,
		) : (),
	},
	recommends => {
		'Test::Pod'           => 1.22,
		'Test::Pod::Coverage' => 0.18,
	},
	meta_merge => {
		resources => {
			license    => 'http://dev.perl.org/licenses/',
			repository => 'http://github.com/Blaizer/ConnectFour',
		},
	},
	add_to_cleanup => [
	],
);

$build->create_build_script;
