## Easy Photograph Geotag

A simple perl script requiring the execellent Image::ExifTool (http://www.sno.phy.queensu.ca/~phil/exiftool/ExifTool.html) to geotag (add GPS data to) JPG photographs on the command line.  NOTE This has not been tested on Windows OS.

## Motivation

Many of my photographs do not have GPS data in the metadata.  I wanted to add the data in the easiest way but none of the solutions I found were as easy as I though they should be.  Now, I look at the photograph, find the location on Google maps and extract the GPS data from the URL (it's the bit that starts with a @ and ends at the next /) and then I call the script on the command line with the pasted geo data.

## Installation

Just download the zip and unzip.  Run script!!!! :)

## Usage

easygeotag.pl $coordinates$ files

e.g. easygeotag.pl @52.4010727,-1.5144245,16z *.jpg

$coordinates$ can be decimal values or degrees, minutes and seconds.

## Contributors

Just little o` me Benjamin Ellis - http://benjyellis.net

## License

Knock yourself out!!!! or in other words WTFPL - https://en.wikipedia.org/wiki/WTFPL

## Caution

No responsibily for use of this script.  If it's important, BACK IT UP!

