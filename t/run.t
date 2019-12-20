use strict;
use warnings;

use Cwd;
use File::Spec;

use Test::Data qw(Array);
use Test::More 1;

use_ok( 'App::grepurl' ) or BAIL_OUT( "App::grepurl did not compile" );
my $corpus  = 'data';

my $file = 'data/index.html';

$ENV{PERL5OPT} = '-Iblib/lib';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
subtest $file => sub {
	my @urls = ();

	@urls  = run( '', $file );
	is( scalar @urls, 80, "Extracts 80 URLs from $file" );

	@urls = run( '-1', $file );
	is( scalar @urls, 42, "Extracts 42 unique URLs from $file" );
	};

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
{
my @table = (
	[ '-a',    80 ],
	[ '-a -1', 42 ],
	[ '-A',    80 ],
	[ '-A -1', 42 ],
	);

foreach my $tuple ( @table ) {
	my( $options, $expected_count ) = @$tuple;
	subtest "$file $options" => sub {
		my @urls = run( $options, $file );
		is( scalar @urls, $expected_count, "Extracts $expected_count URLs from $file with $options" );
		array_sortedstr_ascending_ok( @urls );
		};
	}
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
{
my @table = (
	[ '-e jpg',          42 ],
	[ '-e jpg -1',        6 ],
	[ '-e html',          6 ],
	[ '-e html,jpg',     48 ],
	[ '-h www.theperlreview.com', 5 ],
	[ '-H www.ddj.com',  74 ],
	[ '-s mailto',        3, "Extracts 3 mailto URLs from $file"                      ],
	[ '-s file -b',      51, "Extracts 51 file URLs from $file"                       ],
	[ '-S http',         54, "Extracts 54 non-HTTP URLs from $file"                   ],
	[ '-S http -1',      18, "Extracts 18 unique, relative non-HTTP URLs from $file"  ],
	[ '-S file -b',      29, "Extracts 29 absolute non-file URLs from $file"          ],
	[ '-S file,http -b',  3, "Extracts 3 absolute non-HTTP, non-file URLs from $file" ],
	);

foreach my $tuple ( @table ) {
	my( $options, $expected_count, $label ) = @$tuple;
	$label //= "Extracts $expected_count URLs from $file with $options";
	subtest "$file $options" => sub {
		my @urls = run( $options, $file );
		is( scalar @urls, $expected_count,  $label );
		};
	}
}


done_testing();

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
sub run {
	my( $options, $file ) = @_;

	my $command = 'blib/script/grepurl';
	my $url     = local_file( $file );

	my $command_line = command_line( $command, $options, $url );

	get_output( $command_line );
	}

sub command_line {
	my( $command, $options, $url ) = @_;

	"$command $options -u $url";
	}

sub local_file {
	my( $file ) = @_;

	my $cwd     = cwd;

	my $path    = File::Spec->catfile( $cwd, $corpus, $file );
	my $url     = "file://$path";
	}

sub get_output {
	my $command_line = shift;
	my @lines = `$command_line`;
	}
