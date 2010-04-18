use LWP::UserAgent;

#LWP STUFF
my $ua = LWP::UserAgent->new;
print "Opening delinquents\n";
open IN, '<delinquents.txt';

while(my $line = <IN>) {
	print $line;
	my @values = split(/	/, $line);
	$values[1] =~ s/[\$,]//gsi;
	my $zip = 0;
	print "3".$values[4]."\n";
	if($values[4] =~m/(\d{5})/si) {
		$zip = $1;
	}
	if($zip>0) {
		my $url_request = "http://local.yahooapis.com/MapsService/V1/geocode?appid=StraightUpPimpin2&zip=".$zip;
		my $response = $ua->get($url_request);
		if($response->is_success()) {
			print "success!\n";
			my $content = $response->content;
			print $content."\n";
			if($content =~ m/<Latitude>([^<]+)<\/Latitude><Longitude>([^<]+)/gsi) {
				print "success\n";
				open OUT, ">>latlongdata.csv";
				print OUT $values[0]."	".$values[1]."	".$1."	".$2."\n";
				close OUT;
			}	
		}
		else {
				print "REQUEST ERROR\n";
		}
		sleep(3);
	}
	
}
close IN;
