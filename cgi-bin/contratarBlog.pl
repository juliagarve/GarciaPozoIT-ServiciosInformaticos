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

my $sentencia3 = $dbh->prepare('select contrasena, direccionC, nombre from usuario where nombreUsuario=?');
$sentencia3->execute($usuario);
my $contrasena;
my $correo;
my $nombre;
($contrasena, $correo,$nombre)=$sentencia3->fetchrow();
$contrasena=decode('utf8',$contrasena);
$nombre=decode('utf8',$nombre);

my $sentencia4 = $dbh->prepare('select MD5(?)');
$sentencia4->execute($contrasena);
my $temp1;
($temp1)=$sentencia4->fetchrow();

my $sentencia2 = $dbh->prepare('insert into wp_users (user_login,user_pass,user_nicename,user_email,display_name) values (?,?,?,?,?)');	
$sentencia2->execute($usuario,$temp1,$usuario,$correo,$nombre);

my $sentencia6 = $dbh->prepare('select ID from wp_users where user_login=?');
$sentencia6->execute($usuario);
my $id;
($id)=$sentencia6->fetchrow();

my $meta_key="wp_capabilities";
my $meta_value=qq{a:1:{s:6:"author";b:1;}};

my $sentencia5 = $dbh->prepare('insert into wp_usermeta (user_id,meta_key,meta_value) values (?,?,?)');
$sentencia5->execute($id,$meta_key,$meta_value);

my $sentencia1 = $dbh->prepare('update usuario set blog=1 where nombreUsuario=?');
$sentencia1->execute($usuario);

$dbh->disconnect();

print $cgi->header(-location=>"http://192.168.1.89/cgi-bin/serviciosUsuario.pl");		

exit(0);

