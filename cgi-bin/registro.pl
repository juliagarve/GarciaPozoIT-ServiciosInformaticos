#!/usr/bin/perl

use CGI;
use strict;
use DBI;
use utf8;
use Encode;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $cgi= new CGI;

my $nombre = decode('utf8', $cgi -> param("nombre"));
my $apellidos = decode('utf8', $cgi -> param("apellidos"));
my $direccion = decode('utf8', $cgi -> param("direccion"));
my $correo = decode('utf8', $cgi -> param("correo"));
my $usuario = decode('utf8', $cgi -> param("usuario"));
my $contrasena = decode('utf8', $cgi -> param("contrasena"));
my $contrasena2 = decode('utf8', $cgi -> param("contrasena2"));

my $database = 'DBgarciapozoit';
my $host = 'localhost';
my $username = 'admin';
my $password = 'labii';

my $dbh = DBI->connect("DBI:MariaDB:database=$database;host=$host",$username,$password,{RaiseError=>1,PrintError=>0});

my $sentencia1 = $dbh->prepare('select nombreUsuario from usuario where nombreUsuario=?');
$sentencia1->execute($usuario);
if($sentencia1->fetchrow()){
	print "Location: http://192.168.1.89/registroErroneo.html\n\n";
	$dbh->disconnect();
	exit(0);
}


my $sentencia2 = $dbh->prepare('insert into usuario (nombreUsuario,nombre,apellido,contrasena,direccionP,direccionC,estado,correo,blog,web,creadoWeb) values (?,?,?,?,?,?,?,?,?,?,?)');
$sentencia2->execute($usuario, $nombre,$apellidos,$contrasena,$direccion,$correo,1,0,0,0,0);


$dbh->disconnect();

print "Location: http://192.168.1.89/registroCorrecto.html\n\n";
exit(0);
