# $Id$
use strict;
use warnings;

use ExtUtils::MakeMaker;

eval "use Test::Manifest";

unless( $@ )
	{
	no warnings;
	
	*ExtUtils::MM_Any::test_via_harness = sub
		{
		my($self, $perl, $tests) = @_;
	
		return qq|	$perl "-MTest::Manifest" | .
			qq|"-e" "run_t_manifest(\$(TEST_VERBOSE), '\$(INST_LIB)', | .
			qq|'\$(INST_ARCHLIB)')"\n|;
		};
	}

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
