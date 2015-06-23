#!/usr/bin/perl

#
#	simple geotag photographs
#	original by benjamin ellis, Mukudu Ltd (ben.ellis@mukudu.net)
#	No rights reserved or responsiblity accepted.
#
# 	MAKE BACKUPS B4 USE! MAKE BACKUPS B4 USE!
#

use strict;
use Image::ExifTool;

my $latitude = 0;
my $latituderef = '';
my $longitude =0;
my $longituderef = '';
my $altitude = 0;
my $altituderef = 0;		#above sealevel

if (scalar(@ARGV) < 2) {
	print "\n\tUseage is $0 \$coordinates \$filename/s\n";
	exit(1);
}

my $coords = shift(@ARGV);
#manage spaces in input
$coords =~ s/^\s+|\s(?=\s)|\s+$//g;

# attempt to work out the format of the submitted cordinates
# regex patterns stolen from http://stackoverflow.com/questions/3518504/regular-expression-for-matching-latitude-longitude-coordiates

# if it has two of NSEW in it, it is a non-decimal entry
if ($coords =~ m/[NS]/ && $coords =~ m/[EW]/) {
	#strip out any left over escapes
	$coords =~ s#\\##go;

	#now verify pattern
	my $veripattern = '^[-]?\d{1,2}[ ]ͦ[ ]\d{1,2}.?\d{1,2}[ ]\x27[ ]\w$ ^[-]?\d{1,2}[ ]ͦ[ ]\d{1,2}.?\d{1,2}[ ]\x27[ ]\w$';

	if (!$coords =~ m/$veripattern/) {
		print "Not valid Non-decimal coordinates\n";
		exit(1);
	}
	($latitude,$longitude) = split(' ',$coords);
	$latituderef = chop($latitude);		# N or S
	$latitude .= $latituderef;			#add it back
	$longituderef = chop($longitude);	# E or W
	$longitude .= $longituderef;		#add it back

}else{ # it is decimal
	if ($coords =~ /^@/) {
		# this is a cut and paste from google maps
		$coords =~ s/^@//;
	}

	my @parts = split(',',$coords);
	$coords = $parts[0] . ',' . $parts[1];		# in case there is a altitude input as well - Google's third param a mystery
	my $veripattern = '^([-+]?\d{1,3}[.]\d+),\s*([-+]?\d{1,2}[.]\d+)$';
	if (!$coords =~ m/$veripattern/) {
		print "Not valid Decimal coordinates\n";
		exit(1);
	}
	$latitude = $parts[0];
	$latituderef = int($parts[0]);
	$longitude = $parts[1];
	$longituderef = int($parts[1]);
}

print "Coordinates are $coords\n";



# Create a new Image::ExifTool object
my $exifTool = new Image::ExifTool;
$exifTool->SetNewValue('GPSLatitude', $latitude);
$exifTool->SetNewValue('GPSLongitude', $longitude);
$exifTool->SetNewValue('GPSLatitudeRef', $latituderef);
$exifTool->SetNewValue('GPSLongitudeRef', $longituderef);
$exifTool->SetNewValue('GPSAltitude', $altitude);
$exifTool->SetNewValue('GPSAltitudeRef', $altituderef);

# @ARGV now contains the list of files to work on

#my $filepattern = $ARGV[1];
#my @files = glob($filepattern); # or 'test.*' or '*.txt'

for my $imagefile (@ARGV) {
	if (-e $imagefile) {
		# apply GPS data  to files
		print "Applying to : $imagefile ... ";
		if (!$exifTool->WriteInfo($imagefile)) {
			my $errorMessage = $exifTool->GetValue('Error');
			print $errorMessage;
		}else{
			if (my $warningMessage = $exifTool->GetValue('Warning')) {
				print $warningMessage;
			}else{
				print "Success";
			}
		}
		print "\n";
	}else{
		print "File $imagefile not found\n";
	}
}

