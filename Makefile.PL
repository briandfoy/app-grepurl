# $Id$
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

WriteMakefile(
		'NAME'      => $script_name,
        'VERSION'   => '0.10',

		'EXE_FILES' =>  [ $script_name ],
            
		'PREREQ_PM' => {
				HTML::SimpleLinkExtor => '0',
				LWP::Simple           => '0',
				URI                   => '0',
                },

		'MAN1PODS'  => {
			$script_name => "\$(INST_MAN1DIR)/$script_name.1",
			},

		clean       => { FILES => "*.bak $script_name-*" },
		);
        
1;
