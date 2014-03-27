#!/usr/bin/perl -w

############### KYCS - Kyocera Check Send #######################
# Version : 0.1
# Date :  March 27 2014
# Author  : Arnaud Comein (arnaud.comein@gmail.com)
# Licence : GPL - http://www.fsf.org/licenses/gpl.txt
#################################################################

#Besoin pour les GET SNMP
use BER;
use SNMP_util;
use SNMP_Session;

#Besoin pour le debug - ~mode verbeux sous linux
use strict;
use warnings;

#Variables - "shift" = attente d'argument - !ordre! - Undef par defaut
my $HOST = shift;
my $NUMBER = shift;
my $type;
my $truetype;
my $state;
my $truestate;
my $pagenumber;
my $docname;

#Centralisation des erreurs
my $help = "Correct use : ./kycs.pl HOSTNAME SENDNUMBER[1=Last]\n";
my $errcon = "Unable to connect to $HOST\n";

#Help
($HOST) && ($NUMBER) || die $help;

#GetOID
($type) = &snmpget("public\@$HOST","iso.3.6.1.4.1.1347.47.7.1.1.3.$NUMBER");
($state) = &snmpget("public\@$HOST","iso.3.6.1.4.1.1347.47.7.1.1.5.$NUMBER");
($pagenumber) = &snmpget("public\@$HOST","iso.3.6.1.4.1.1347.47.7.1.1.10.$NUMBER");
($docname) = &snmpget("public\@$HOST","iso.3.6.1.4.1.1347.47.7.1.1.4.$NUMBER");

if ($type == 4)
{ $truetype = "FAX"; }
if ($type == 6)
{ $truetype = "EMAIL"; }
if ($state == 0)
{ $truestate = "SEND"; }
else
{ $truestate = "NOT SEND"; }

#Prevoir une sortie si la connexion à l'hote ne se fait pas
if ($type)
{
	#Retour Shinken WebUI
	print "Document $docname is a $truetype of $pagenumber pages and it is $truestate\n";

} #Fin de la sortie en cas d'erreur de connexion

else 
{ print $errcon; }
