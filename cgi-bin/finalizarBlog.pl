#!/usr/bin/perl

use CGI;
use strict;
use DBI;
use utf8;
use Encode;
use CGI::Session();
use Template;
use LWP::Simple;
use File::Path qw(rmtree);

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

my $sentencia3 = $dbh->prepare('select ID from wp_users where user_login=?');
$sentencia3->execute($usuario);
my $id;
($id)=$sentencia3->fetchrow();

my $sentencia2 = $dbh->prepare('delete from wp_users where ID=?');	
$sentencia2->execute($id);

my $sentencia4 = $dbh->prepare('delete from wp_usermeta where user_id=?');
$sentencia4->execute($id);

my $sentencia1 = $dbh->prepare('update usuario set blog=0 where nombreUsuario=?');
$sentencia1->execute($usuario);
	
$dbh->disconnect();

print $cgi->header(-location=>"http://192.168.1.89/cgi-bin/serviciosUsuario.pl");

exit(0);

