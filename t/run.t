use strict;
use warnings;

use Cwd;
use File::Spec;
use URI;

use Test::Data qw(Array);
use Test::More tests => 22;

my $corpus  = 'data';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
my $file = 'index.html';
my @urls = ();

@urls  = run( '', $file );
is( scalar @urls, 80, "Extracts 80 URLs from $file" );

@urls = run( '-1', $file );
is( scalar @urls, 42, "Extracts 42 unique URLs from $file" );


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
@urls = run( '-a', $file );
is( scalar @urls, 80, "Extracts 80 URLs from $file" );
array_sortedstr_ascending_ok( @urls );

@urls = run( '-a -1', $file );
is( scalar @urls, 42, "Extracts 42 URLs from $file" );
array_sortedstr_ascending_ok( @urls );

@urls = run( '-A', $file );
is( scalar @urls, 80, "Extracts 80 URLs from $file" );
array_sortedstr_descending_ok( @urls );

@urls = run( '-A -1', $file );
is( scalar @urls, 42, "Extracts 42 URLs from $file" );
array_sortedstr_descending_ok( @urls );


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
@urls = run( '-e jpg', $file );
is( scalar @urls, 42, "Extracts 42 jpg URLs from $file" );

@urls = run( '-e jpg -1', $file );
is( scalar @urls, 6, "Extracts 6 unique jpg URLs from $file" );

@urls = run( '-e html', $file );
is( scalar @urls, 6, "Extracts 6 html URLs from $file" );

@urls = run( '-e jpg,html', $file );
is( scalar @urls, 48, "Extracts 42 jpg and html URLs from $file" );


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
@urls = run( '-h www.theperlreview.com', $file );
is( scalar @urls, 5, "Extracts 42 jpg and html URLs from $file" );

@urls = run( '-H www.ddj.com', $file );
is( scalar @urls, 74, "Extracts 42 jpg and html URLs from $file" );


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
@urls = run( '-s mailto', $file );
is( scalar @urls, 3, "Extracts 3 mailto URLs from $file" );

@urls = run( '-s file -b', $file );
is( scalar @urls, 51, "Extracts 51 file URLs from $file" );

@urls = run( '-S http', $file );
is( scalar @urls, 54, "Extracts 54 non-HTTP URLs from $file" );

@urls = run( '-S http -1', $file );
is( scalar @urls, 18, "Extracts 18 unique, relative non-HTTP URLs from $file" );

@urls = run( '-S file -b', $file );
is( scalar @urls, 29, "Extracts 29 absolute non-file URLs from $file" );

@urls = run( '-S file,http -b', $file );
is( scalar @urls, 3, "Extracts 3 absolute non-HTTP, non-file URLs from $file" );



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
