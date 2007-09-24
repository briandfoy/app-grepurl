# $Id$
use strict;
use warnings;

use ExtUtils::MakeMaker;

eval "use Test::Manifest 1.14";

my $script_name = "grepurl";

sub my_WriteMakefile
	{
	my %hash = @_;
	
	my $prereqs = $hash{PREREQ_PM};
	
	open my( $fh ), '> prereqs' or warn "Could not open prereqs: $!";

	foreach my $module ( sort keys %$prereqs )
		{
		print $fh "$module\n";		
		}

	close $fh;
		
	&WriteMakefile;
	}
	
my_WriteMakefile(
		'NAME'      => $script_name,
        'VERSION'   => '0.12',

		'EXE_FILES' =>  [ $script_name ],
            
		'PREREQ_PM' => {
				'Test::Data'            => '0.95',
				'HTML::SimpleLinkExtor' => '0',
				'LWP::Simple'           => '0',
				URI                     => '0',
                },

		'MAN1PODS'  => {
			$script_name => "\$(INST_MAN1DIR)/$script_name.1",
			},

		clean       => { FILES => "*.bak $script_name-* prereqs" },
		);
        
1;
