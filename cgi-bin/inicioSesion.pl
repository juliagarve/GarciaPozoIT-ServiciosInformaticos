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

my $usuario = decode('utf8', $cgi -> param("usuario", $cgi->param("usuario")));
my $contrasenaIntroducida = decode('utf8', $cgi -> param("contrasena", $cgi->param("contrasena")));
my $contrasenaReal;
my $estado;

my $archivo = '/var/log/inicioWeb.log';
my $fh;
open($fh,'>>:encoding(utf8)',$archivo) or die "No se puede abrir el log inicioWeb: $!";
my $fecha = DateTime->now()->strftime("%d-%m-%Y %H:%M:%S");

my $database = 'DBgarciapozoit';
my $host = 'localhost';
my $username = 'admin';
my $password = 'labii';

my $dbh = DBI->connect("DBI:MariaDB:database=$database;host=$host",$username,$password,{RaiseError=>1,PrintError=>0});

my $sentencia1 = $dbh->prepare('select contrasena,estado from usuario where nombreUsuario=?');
$sentencia1->execute($usuario);
if(($contrasenaReal,$estado) = $sentencia1->fetchrow()){
	
	if($estado!=3){
                $dbh->disconnect();		
		print $fh "$fecha: Inicio de sesión fallido de $usuario. No ha validado correo\n";
		close($fh);

                print "Location: http://192.168.1.89/inicioSesionErroneo.html\n\n";
		exit(0);
        }

	
	if($contrasenaIntroducida eq $contrasenaReal){

		print $fh "$fecha: Inicio de sesión correcto de $usuario\n";
		close($fh);

		my $sesion = CGI::Session->new();
		$sesion->param('usuario', $usuario);
		$sesion->expires("+1h");
		$sesion->flush();
		$dbh->disconnect();

		print $sesion->header(-location=>"http://192.168.1.89/cgi-bin/serviciosUsuario.pl");
		exit(0);

	}else{
		print $fh "$fecha: Inicio de sesión fallido de $usuario. Contraseña incorrecta\n";
		close($fh);
		$dbh->disconnect();
        	print "Location: http://192.168.1.89/inicioSesionErroneo.html\n\n";
		exit(0);

	}
}else{
	$dbh->disconnect();
	print $fh "$fecha: Inicio de sesión fallido de un usuario no registrado. Usuario no registrado: $usuario\n";
	print "Location: http://192.168.1.89/inicioSesionErroneo.html\n\n";
	close($fh);
	exit(0);	
}

