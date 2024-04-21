#!/usr/bin/perl

use File::Path qw(rmtree);
use utf8;
use CGI::Session;
use CGI;
use DBI;
use Encode;
use utf8;

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

my $rutaDirectorio = "/var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario";

system("sudo rm -r $rutaDirectorio");

my $sentencia1 = $dbh->prepare('update usuario set web=0 where nombreUsuario=?');
$sentencia1->execute($usuario);

$dbh->disconnect();

print $cgi->header(-location=>"http://192.168.1.89/cgi-bin/serviciosUsuario.pl");

exit(0);


