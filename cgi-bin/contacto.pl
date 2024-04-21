#!/usr/bin/perl

use CGI;
use strict;
use DBI;
use utf8;
use Encode;
use CGI::Session();
use Template;
use LWP::Simple;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $cgi= new CGI;

my $sesion = new CGI::Session;

$sesion->load();
my @autenticar = $sesion->param;

if($sesion->is_expired){
	$sesion->delete();
	$sesion->flush();
	print "Location: http://192.168.1.89/inicioSesion.html\n\n";
        exit(0);
}

my $usuario  = decode('utf8', $sesion -> param("usuario"));

unless($usuario){
	$sesion->delete();
        $sesion->flush();
        print "Location: http://192.168.1.89/inicioSesion.html\n\n";
        exit(0);

}

my $insertar;
$insertar->{nombre_usuario}=$usuario;		

my $plantilla = Template->new({ENCODING => 'utf8',});
my $output;
$plantilla->process('contacto.html',$insertar,\$output);
print $cgi->header(-charset =>'UTF-8');
print $output;
exit(0);
