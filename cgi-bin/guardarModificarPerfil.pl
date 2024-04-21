#!/usr/bin/perl

use CGI;
use strict;
use DBI;
use utf8;
use Encode;
use CGI::Session;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $cgi= new CGI;

my $cgi= new CGI;

my $sesion = new CGI::Session;

$sesion->load();

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



my $nombre = decode('utf8', $cgi -> param("nombre"));
my $apellidos = decode('utf8', $cgi -> param("apellidos"));
my $direccion = decode('utf8', $cgi -> param("direccion"));
my $correo = decode('utf8', $cgi -> param("correo"));
my $contrasena = decode('utf8', $cgi -> param("contrasena"));

my $database = 'DBgarciapozoit';
my $host = 'localhost';
my $username = 'admin';
my $password = 'labii';

my $dbh = DBI->connect("DBI:MariaDB:database=$database;host=$host",$username,$password,{RaiseError=>1,PrintError=>0});

my $sentencia2 = $dbh->prepare('update usuario set nombre=?,apellido=?,contrasena=?,direccionP=?,direccionC=? where nombreUsuario=?');
$sentencia2->execute($nombre,$apellidos,$contrasena,$direccion,$correo,$usuario);

$dbh->disconnect();

print "Location: http://192.168.1.89/cgi-bin/verPerfil.pl\n\n";
exit(0);
