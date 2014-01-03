use strict;
use warnings;

use ExtUtils::MakeMaker;

require 5.008;

eval "use Test::Manifest 1.21";

my $script_name = "grepurl";
	
WriteMakefile(
	'NAME'      => $script_name,
	'VERSION'   => '1.02',
	'ABSTRACT'  => 'Extract URLs from text',

	'EXE_FILES' =>  [ $script_name ],
		
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
