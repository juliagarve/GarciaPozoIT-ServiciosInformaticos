#!/usr/bin/perl

use CGI;
use DBI;
use Linux::usermod;
use File::Copy;
use Quota;
use User::grent;
use User::pwent;


my $cgi= new CGI;

my $usuario = $cgi -> param("usuario");
my $clave = $cgi -> param("clave");
my $contrasena;
my $claveReal;

my $database = 'DBgarciapozoit';
my $host = 'localhost';
my $username = 'admin';
my $password = 'labii';

my $dbh = DBI->connect("DBI:MariaDB:database=$database;host=$host",$username,$password,{RaiseError=>1,PrintError=>0});

my $sentencia1 = $dbh->prepare('select nombreUsuario,clave,contrasena from usuario where nombreUsuario=?');
$sentencia1->execute($usuario);
if(($usuario,$claveReal,$contrasena) = $sentencia1->fetchrow()){
	if($clave ne $claveReal){
		$dbh->disconnect();
                print "Location: http://192.168.1.89/confirmarRegistroErroneo.html\n\n";
		exit(0);
	}
	
	my $sentencia2 = $dbh->prepare('update usuario set estado=3 where nombreUsuario=?');
	$sentencia2->execute($usuario);

	$dbh->disconnect();

	my $ruta="/home/".$usuario."/";
	#print "La tura /home es: $ruta\n";
	mkdir ($ruta);
	chmod(0770,$ruta); # || print $!;
	my $subruta = $ruta . "public_html";
        mkdir $subruta;
	
	Linux::usermod->add($usuario,$contrasena,'',1001,'',$ruta,"/bin/bash"); #|| print "USERADD: $!\n";
	my $user=Linux::usermod->new($usuario);
	my $uid = $user->get(uid);
	my $gid = $user->get(gid);

	copy("/etc/skel/.bash_logout", $ruta . ".bash_logout");
        copy("/etc/skel/.bashrc", $ruta . ".bashrc");
        copy("/etc/skel/.profile", $ruta . ".profile");
	
	system("sudo chown $usuario:$gid $ruta");
	system("sudo chown $usuario:$gid $subruta");

	Quota::setqlim("/dev/loop0",$uid,71680,81920,0,0,0);		

	print "Location: http://192.168.1.89/registroConfirmado.html\n\n";
	exit(0);
}

print $cgi->header;
print $cgi->start_html("GarciaPozoIT");
print "<h2>No se ha podido confirmar al usuario $usuario</h2>";
print end_html;
exit(0);
