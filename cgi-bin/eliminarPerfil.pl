#!/usr/bin/perl

use File::Path qw(rmtree);
use CGI;
use strict;
use DBI;
use utf8;
use Encode;
use CGI::Session();
use Template;
use LWP::Simple;
use Linux::usermod;

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

	$sesion->param('borrar', 1);

	my $database = 'DBgarciapozoit';
	my $host = 'localhost';
	my $username = 'admin';
	my $password = 'labii';

	my $dbh = DBI->connect("DBI:MariaDB:database=$database;host=$host",$username,$password,{RaiseError=>1,PrintError=>0});

	my $correo;
	my $blog;
	my $web;

	my $sentencia1 = $dbh->prepare('select correo,blog,web from usuario where nombreUsuario=?');
        $sentencia1->execute($usuario);
        if(($correo,$blog,$web) = $sentencia1->fetchrow()){
	
		if($correo==1){
			$correo = $usuario . "\@garciapozoit.com";

			my $sentencia2 = $dbh->prepare('delete from virtual_users where email=?');
			$sentencia2->execute($correo);

			my $carpeta = "/home/vmail/garciapozoit.com/$usuario";
			rmtree($carpeta);

		}
                if($blog==1){
			my $sentencia3 = $dbh->prepare('select ID from wp_users where user_login=?');
			$sentencia3->execute($usuario);
			my $id;
			($id)=$sentencia3->fetchrow();

			my $sentencia4 = $dbh->prepare('delete from wp_users where ID=?');
			$sentencia4->execute($id);

			my $sentencia5 = $dbh->prepare('delete from wp_usermeta where user_id=?');
			$sentencia5->execute($id);

		}
                if($web==1){
			my $rutaDirectorio = "/var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario";

			system("sudo rm -r $rutaDirectorio");
		}

		my $sentencia1 = $dbh->prepare('delete from usuario where nombreUsuario=?');
                $sentencia1->execute($usuario);

		system("sudo rm -r /home/$usuario");
		Linux::usermod->del($usuario);
		#system("sudo userdel $usuario");	

                print $cgi->header(-location=>"http://192.168.1.89/cgi-bin/cerrarSesion.pl");
		
	}
	$dbh->disconnect();
		
	exit(0);

