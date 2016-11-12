use strict;
use warnings;

use Moo;
use feature qw(say);
use Data::Dumper;

# use GD::Graph::points;

# my $graph = GD::Graph::points->new;
# $graph->set( 
#         x_label     => 'Label', 
#         y_label     => 'Values', 
#         title          => 'Label By Value', 
#         dclrs         => [ 'black', 'black','black','black','black','black','black'], 
#         borderclrs     => [ qw(black black), qw(black black) ], 
#         bar_spacing => 4, 
#         transparent => 1,
#         show_values => 1, 
# ); 

open(IN, "< irisdata.txt");
my $count = 0;

my @result;
while(<IN>){
  if($count==0){
    $count++; 
    next;
  }
  my @array = split('\s',$_);
  push(@result, @array);
}

print Dumper @result;

# foreach my $array_reference(@result){
#   foreach my $a(@$array_reference){
#     print $a;
#   }
#   print '--------------';
# }

close(IN);




