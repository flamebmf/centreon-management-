#!/usr/bin/perl -w
$num_args = $#ARGV + 1;

if ($num_args != 1) {
    print "\nUsage: import.pl filename to import\n";
    exit;
}
$filename=$ARGV[0];
open(FILE,"$filename")or die "нет файла..пропал...кудааааа?..найдите мне его";
@list_hosts=<FILE>;
close(FILE);
#&timezones;

foreach $line(@list_hosts){
	   chomp($line);
	   ( $key, $host_name, $alias,$_ip,$act ) = split (/\;/,$line);
	   
         $result=`centreon -u DAkulich -p ytdflyjgj -o HOST -a setinstance -v "$host_name;Central"`;
		print "$host_name\t$result\n"
		}
	



