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
	my $nombre;
	my $apellido;
	my $direccionC;
	my $direccionP;
	my $contrasena;

	my $database = 'DBgarciapozoit';
	my $host = 'localhost';
	my $username = 'admin';
	my $password = 'labii';

	my $dbh = DBI->connect("DBI:MariaDB:database=$database;host=$host",$username,$password,{RaiseError=>1,PrintError=>0});

	my $sentencia1 = $dbh->prepare('select nombre,apellido,direccionC,direccionP,contrasena from usuario where nombreUsuario=?');
	$sentencia1->execute($usuario);
	if(($nombre,$apellido,$direccionC,$direccionP,$contrasena) = $sentencia1->fetchrow()){
	
		$dbh->disconnect();
		
		$insertar->{nombre_usuario}=$usuario;
		$insertar->{nombre}=$nombre;
		$insertar->{apellido}=$apellido;
                $insertar->{direccionP}=$direccionP;
                $insertar->{direccionC}=$direccionC;
                $insertar->{usuario}=$usuario;
                $insertar->{contrasena}=$contrasena;

		my $plantilla = Template->new({ENCODING => 'utf8',});
		my $output;
        	$plantilla->process('modificarPerfil.html',$insertar,\$output);
        	print $cgi->header(-charset =>'UTF-8');
		print $output;
#print $cgi->header;
#print $cgi->start_html("HOLA");
#print "<h2>Inicio correcto $usuario</h2>";
#print end_html;
	}
	exit(0);

