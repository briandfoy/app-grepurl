require 5.008;
use strict;
use warnings;

my $script_name = "grepurl";
	
my $github    = 'https://github.com/briandfoy/';
my $main_file = 'lib/';

my %WriteMakefile = (
	'NAME'          => $script_name,
	'VERSION_FROM'  => $main_file,
	'ABSTRACT_FROM' => $main_file,
	'EXE_FILES'     =>  [ $script_name ],
	'AUTHOR'        => 'brian d foy <bdfoy@cpan.org>',
		
	'PREREQ_PM' => {
		'Test::Data'            => '0.95',
		'HTML::SimpleLinkExtor' => '0',
		'LWP::Simple'           => '0',
		'URI'                   => '0',
		},

	'MAN1PODS'  => {
		$script_name => "\$(INST_MAN1DIR)/$script_name.1",
		},

	'META_MERGE' => {
        'meta-spec' => { version => 2 },
		resources => {
			repository => {
				type => 'git',
				url  => 'git@github.com:briandfoy/grepurl.git',
				web  => 'https://github.com/briandfoy/grepurl',
				},
			},
		},

	clean       => { FILES => "*.bak $script_name-* prereqs" },
	);
        
1;

sub arguments { \%WriteMakefile }

do_it() unless caller;
sub do_it {
	require File::Spec;
	my $MM ='ExtUtils::MakeMaker';
	my $MM_version =
		eval{ "$MM " . $WriteMakefile{'CONFIGURE_REQUIRES'}{'ExtUtils::MakeMaker'} }
			//
		"$MM 6.64";
	eval "use $MM_version";
	eval "use Test::Manifest 1.21" 
		if -e File::Spec->catfile( qw(t test_manifest) );
	WriteMakefile( %WriteMakefile );
	}


no warnings;
__PACKAGE__;
