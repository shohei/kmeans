use strict;
use warnings;

use Moo;
use feature qw(say);
use Switch;
use Data::Dumper;
use List::Util qw(first max maxstr min minstr reduce shuffle sum);
use POSIX;

# k-means clustering
# k=3
# iris data from R

# initialize constant
my $loop_count = 0;
my $smax=0;
my $smin=1000; #should be large enough
my $lmax=0;
my $lmin=1000; #should be large enough
my $global_max; 
my $global_min; 

my @points;
sub read_file(){
    open(IN, "< ./dat/irisdata.txt");
	while(<IN>){
		if($loop_count==0){
			$loop_count++; 
			next;
		}
		my @array = split('\s',$_);
    push(@array,0); # this is label (=k)

    $smax=max($smax,$array[0]);
    $smin=min($smin,$array[0]);
    $lmax=max($lmax,$array[1]);
    $lmin=min($lmin,$array[1]);

    push(@points, \@array);
}
close(IN);
$global_max = max($smax,$lmax);
$global_min = min($smin,$lmin);
}

my @centers; 

sub select_random_center{
	for(my $i=0;$i<3;$i++){
	  my $xc = rand($global_max-$global_min)+$global_min;
	  my $yc = rand($global_max-$global_min)+$global_min;
	  my $pair = [$xc,$yc];
	  @centers[$i] = $pair;
	}
}

sub select_center_from_sample{
	my $length = $#points+1;
	for(my $i=0;$i<3;$i++){
	  my $xc = $points[floor(rand($length))][0];
	  my $yc = $points[floor(rand($length))][1];
	  my $pair = [$xc,$yc];
	  @centers[$i] = $pair;
	}
}

sub assign_label{
	foreach my $point(@points){
		my $xp = $point->[0];
		my $yp = $point->[1];
		my $label = 0;
		my $min_norm = $global_max**2; # should be large enough
		foreach my $center(@centers){
			my $xc = $center->[0];
			my $yc = $center->[1];
			my $norm = sqrt(($xp-$xc)**2 + ($yp-$yc)**2);
			if($norm<$min_norm){
				$point->[3] = $label;
				$min_norm = $norm;
			}
			$label++;
		}
	}
}

sub recalculate_center(){
	my @x0s;
	my @y0s;
	my @x1s;
	my @y1s;
	my @x2s;
	my @y2s;
	foreach my $point(@points){
		switch($point->[3]){
			case 0 {
			  push(@x0s,$point->[0]);
			  push(@y0s,$point->[1]);
			}
			case 1 {
			  push(@x1s,$point->[0]);
			  push(@y1s,$point->[1]);
			}
			case 2 {
			  push(@x2s,$point->[0]);
			  push(@y2s,$point->[1]);
			}
		}
	}

	my $new_x0;
	my $new_y0;
	my $count;
  	$count = $#x0s + 1;
	if($count>0){
	  for (my $i=0;$i<$count;$i++){
		$new_x0 += $x0s[$i];
		$new_y0 += $y0s[$i];
	  }
	  $new_x0 = $new_x0 / $count;
	  $new_y0 = $new_y0 / $count;
	  my $new_pair0 = [$new_x0,$new_y0];
	  @centers[0] = $new_pair0;
	}

	my $new_x1;
	my $new_y1;
	$count = $#x1s + 1;
	if($count>0){
	  for (my $i=0;$i<$count;$i++){
		  $new_x1 += $x1s[$i];
		  $new_y1 += $y1s[$i];
	  }
	  $new_x1 = $new_x1 / $count;
	  $new_y1 = $new_y1 / $count;
	  my $new_pair1 = [$new_x1,$new_y1];
	  @centers[1] = $new_pair1;
	} 

	my $new_x2;
	my $new_y2;
	$count = $#x2s + 1;
	if($count>0){
	  for (my $i=0;$i<$count;$i++){
		  $new_x2 += $x2s[$i];
		  $new_y2 += $y2s[$i];
	  }
	  $new_x2 = $new_x2 / $count;
	  $new_y2 = $new_y2 / $count;
	  my $new_pair2 = [$new_x2,$new_y2];
	  @centers[2] = $new_pair2;
	} 
}

sub write_to_file(){
	open(OUT,'> result.csv');

	foreach my $point(@points){
	  print OUT $point->[0] . ',';	
	  print OUT $point->[1] . ',';	
	  print OUT $point->[2] . ',';	
	  print OUT $point->[3] . "\n";	
	}
	close(OUT);

	open(OUT,'> center.csv');

	foreach my $center(@centers){
	  print OUT $center->[0] . ',';	
	  print OUT $center->[1] . ',';	
	  print OUT "center" . "\n";	
	}
	close(OUT);
}

sub k_means(){
  read_file();
  # select_random_center();
  select_center_from_sample();
  # loop for 1000 times
	for(my $i=0;$i<1000;$i++){
	  assign_label();
	  recalculate_center();
	  say "loop $i has finished";
	}

	say 'computation done.';
	say Dumper @centers;

	write_to_file();
}

k_means();

