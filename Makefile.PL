require 5.008;
use strict;
use warnings;

my $script_name = "grepurl";
	
my $module    = 'App::grepurl';
( my $dist = $module ) =~ s/::/-/g;

my $github    = 'https://github.com/briandfoy/grepurl';
my $main_file = catfile( 'lib', split /::/, "$module.pm" );

my %WriteMakefile = (
	'NAME'          => $script_name,
	'VERSION_FROM'  => $main_file,
	'ABSTRACT_FROM' => $main_file,
	'AUTHOR'        => 'brian d foy <bdfoy@cpan.org>',

	'EXE_FILES'     =>  [ $script_name ],

	'CONFIGURE_REQUIRES' => {
		'ExtUtils::MakeMaker'   => '6.64',
		'File::Spec::Functions' => '0',
		},

	'BUILD_REQUIRES' => {
		},

	'TEST_REQUIRES' => {
		'Test::More' => '0.94',
		'Test::Data' => '0.95',
		},

	'PREREQ_PM'     => {
		'HTML::SimpleLinkExtor' => '0',
		'LWP::Simple'           => '0',
		'URI'                   => '0',
		},

	'META_MERGE' => {
		'meta-spec' => { version => 2 },
		resources => {
			repository => {
				type => 'git',
				url  => "$github.git",
				web  => $github,
				},
			bugtraker => {
				web    => "$github/issues",
				},
			homepage => $github,
			},
		},
		
	'MAN1PODS'  => {
		$script_name => "\$(INST_MAN1DIR)/$script_name.1",
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
			||
		"$MM 6.64";
	eval "use $MM_version; 1" or die "Could not load $MM_version: $@";
	eval "use Test::Manifest 1.21" 
		if -e File::Spec->catfile( qw(t test_manifest) );
	WriteMakefile( %WriteMakefile );
	}


no warnings;
__PACKAGE__;
