#!/usr/bin/perl -w
$user_names="DAkulich";
$user_pwd="ytdflyjgj";
$num_args = $#ARGV + 1;

if ($num_args != 1) {
    print "\nUsage: import.pl filename to import\n";
    exit;
}
$SAP="SAP_ZONE.csv";
open(FILE,$SAP)or die "нет файла..пропал...кудааааа?..найдите мне его";
@list_h=<FILE>;
close(FILE);

foreach $sap_line(@list_h){
        ( $key, $mag_name, $city ) = split (/\;/,$sap_line);
#        print "$sap_line\n";
        chomp($key);
        chomp($mag_name);
		chomp($city);
	$mag_hash{$key} = "$mag_name";
	print "mag-hash($key)=$mag_hash{$key}\n";
	$mag_city_hash{$key} = "$city";
	}

$filename=$ARGV[0];
open(FILE,"$filename")or die "нет файла..пропал...кудааааа?..найдите мне его";
@list_hosts=<FILE>;
close(FILE);

foreach $host_line(@list_hosts){
        $key =$host_line;
        chomp($key);
        #print "$key\n";
        $num=substr $key,0,4;
        #print "$num\n";
        
        $alias="$mag_hash{$num} WKS $mag_city_hash{$num}";
        $IP="$key.stores.adam.net";
        $tmpl="wks_1";
        $host_grp=$mag_hash{$num};
        $host_adm=$mag_city_hash{$num};
	$tmpl="wks_1";
        $field_1="$key";
	$filed_2="$alias";
	print "creating field_1=$field_1, field_2=$filed_2, IP=$IP , type=$tmpl \n";
		
		&add_host;
		&add_param_wks;
        }

sub add_host {
 $host_add_=`centreon -u $user_names  -p $user_pwd -o HOST -a ADD -v \"$field_1\;$filed_2\;$IP\;$tmpl\;sephora\;$host_adm\"`;
 print "$host_add_ add\n ";
 }


 sub add_param_wks {
 $zones="24x7";
 $wrkh_set_param=`centreon -u $user_names  -p $user_pwd -o HOST -a setparam -v \"$field_1;check\_period;$zones"`;
 $set_param=`centreon -u $user_names  -p $user_pwd -o HOST -a setparam -v \"$field_1\;cg_additive_inheritance;1\"`;
 $set_param=`centreon -u $user_names  -p $user_pwd -o HOST -a setparam -v \"$field_1\;check_command;check_centreon_ping;\!3\!200,20\%\!400,50\%1\"`;
 $set_param=`centreon -u $user_names  -p $user_pwd -o HOST -a setparam -v \"$field_1\;check_command_arguments;\!3\!200,20\%\!400,50\%1\"`;
 $host_add_=`centreon -u $user_names  -p $user_pwd -o HOST -a APPLYTPL -v \"$field_1\"`;
 $host_add_cgrp=`centreon -u $user_names  -p $user_pwd -o HOST -a addcontactgroup -v \"$field_1;$host_adm\"`;
 print "set host param \n";
 }