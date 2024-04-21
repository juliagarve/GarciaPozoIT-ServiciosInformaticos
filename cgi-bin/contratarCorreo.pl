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

my $database = 'DBgarciapozoit';
my $host = 'localhost';
my $username = 'admin';
my $password = 'labii';

my $dbh = DBI->connect("DBI:MariaDB:database=$database;host=$host",$username,$password,{RaiseError=>1,PrintError=>0});

my $sentencia1 = $dbh->prepare('update usuario set correo=1 where nombreUsuario=?');
$sentencia1->execute($usuario);

my $sentencia3 = $dbh->prepare('select contrasena from usuario where nombreUsuario=?');
$sentencia3->execute($usuario);
my $contrasena;
($contrasena)=$sentencia3->fetchrow();
$contrasena=decode('utf8',$contrasena);

my $correo = $usuario . "\@garciapozoit.com";

my $sentencia4 = $dbh->prepare('select rand()');
$sentencia4->execute();
my $temp1;
($temp1)=$sentencia4->fetchrow();

my $sentencia5 = $dbh->prepare('select SHA(?)');
$sentencia5->execute($temp1);
my $temp2;
($temp2)=$sentencia5->fetchrow();

my $sentencia6 = $dbh->prepare('select SUBSTRING(?,?)');
$sentencia6->execute($temp2,-16);
my $temp3;
($temp3)=$sentencia6->fetchrow();

my $sentencia7 = $dbh->prepare('select concat(?,?)');
$sentencia7->execute('$6$',$temp3);
my $temp4;
($temp4)=$sentencia7->fetchrow();

my $sentencia8 = $dbh->prepare('select encrypt(?,?)');
$sentencia8->execute($contrasena,$temp4);
my $temp5;
($temp5)=$sentencia8->fetchrow();

my $sentencia2 = $dbh->prepare('insert into virtual_users (domain_id, password, email) values (?,?,?);');	
$sentencia2->execute(1,$temp5, $correo);
	
$dbh->disconnect();

print $cgi->header(-location=>"http://192.168.1.89/cgi-bin/serviciosUsuario.pl");		

exit(0);

