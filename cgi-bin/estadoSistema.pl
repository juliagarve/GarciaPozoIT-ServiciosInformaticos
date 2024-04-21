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

my ($estado1,$estado2,$estado3,$estado4,$estado5,$estado6) = @ARGV;

my $insertar;
		
$insertar->{nombre_usuario}=$usuario;		
$insertar->{estado1}=$estado1;
if($estado1 eq "active"){
	$insertar->{color1}="#8CFCA4";
	$insertar->{icono1}="fa fa-check-circle";
}else{
        $insertar->{color1}="#8CFCA4";
        $insertar->{icono1}="fa fa-check-circle";

}

$insertar->{estado2}=$estado2;
if($estado2 eq "active"){
        $insertar->{color2}="#8CFCA4";
        $insertar->{icono2}="fa fa-check-circle";
}else{
        $insertar->{color2}="#8CFCA4";
        $insertar->{icono2}="fa fa-check-circle";

}

$insertar->{estado3}=$estado3;
if($estado3 eq "active"){
        $insertar->{color3}="#8CFCA4";
        $insertar->{icono3}="fa fa-check-circle";
}else{
        $insertar->{color3}="#8CFCA4";
        $insertar->{icono3}="fa fa-check-circle";

}

$insertar->{estado4}=$estado4;
if($estado4 eq "active"){
        $insertar->{color4}="#8CFCA4";
        $insertar->{icono4}="fa fa-check-circle";
}else{
        $insertar->{color4}="#8CFCA4";
        $insertar->{icono4}="fa fa-check-circle";

}

$insertar->{estado5}=$estado5;
if($estado5 eq "active"){
        $insertar->{color5}="#8CFCA4";
        $insertar->{icono5}="fa fa-check-circle";
}else{
        $insertar->{color5}="#8CFCA4";
        $insertar->{icono5}="fa fa-check-circle";

}

$insertar->{estado6}=$estado6;
if($estado6 eq "active"){
        $insertar->{color6}="#8CFCA4";
        $insertar->{icono6}="fa fa-check-circle";
}else{
        $insertar->{color6}="#8CFCA4";
        $insertar->{icono6}="fa fa-check-circle";

}

my $plantilla = Template->new({ENCODING => 'utf8',});
my $output;
$plantilla->process('plantillaEstadoServicios.html',$insertar,\$output);
print $cgi->header(-charset =>'UTF-8');
print $output;
exit(0);

