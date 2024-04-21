#!/usr/bin/perl

use CGI;
use strict;
use DBI;
use utf8;
use Encode;
use CGI::Session();
use Template;
use LWP::Simple;
use DateTime;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $cgi= new CGI;

my $sesion = new CGI::Session;

$sesion->load();
my $usuario  = decode('utf8', $sesion -> param("usuario"));

my $archivo = '/var/log/inicioWeb.log';
my $fh;
open($fh,'>>:encoding(utf8)',$archivo) or die "No se puede abrir el log inicioWeb: $!";
my $fecha = DateTime->now()->strftime("%d-%m-%Y %H:%M:%S");
print $fh "$fecha: Cierre de sesión de $usuario\n";
close($fh);

$sesion->delete();
$sesion->flush();

print "Location: http://192.168.1.89/inicioSesion.html\n\n";
exit(0);
