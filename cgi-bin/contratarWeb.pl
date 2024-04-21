#!/usr/bin/perl

use CGI;
use CGI::Session;
use Encode;
use DBI;
#use IPC::System::Simple qw(system sudo);

my $cgi= new CGI;

my $sesion = new CGI::Session;

$sesion->load();
my @autenticar = $sesion->param;

if($sesion->is_expired){
        $sesion->delete();
        $sesion->flush();
        #print "Location: http://192.168.1.89/inicioSesion.html\n\n";
        exit(0);
}

my $usuario  = decode('utf8', $sesion -> param("usuario"));

unless($usuario){
        $sesion->delete();
        $sesion->flush();
        #print "Location: http://192.168.1.89/inicioSesion.html\n\n";
        exit(0);

}

my $database = 'DBgarciapozoit';
my $host = 'localhost';
my $username = 'admin';
my $password = 'labii';

my $dbh = DBI->connect("DBI:MariaDB:database=$database;host=$host",$username,$password,{RaiseError=>1,PrintError=>0});

#Necesitamos recoger la variable para saber si el fichero de ssh ya esta editado
my $registradoAnterior;
my $sentencia1 = $dbh->prepare('select creadoWeb from usuario where nombreUsuario=?');
$sentencia1->execute($usuario);
($registradoAnterior) = $sentencia1->fetchrow();

#ademas guardaremos la primera vez que acceda en la base de datos

system("sudo chown www-data:www-data /var/www/GarciaPozoIT/paginasWebUsuarios");

mkdir ("/var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario");
mkdir ("/var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario/meter_aqui_tus_paginas_webs");
mkdir ("/var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario/dev");
open (fichero ,">> /var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario/meter_aqui_tus_paginas_webs/index.html");

print fichero "<!DOCTYPE html>\n\n";
print fichero "<head>\n";
print fichero (qq(<meta http-equiv="Content-Type" content="text/html; charset=UTF8" />\n));
print fichero "</head>\n";
print fichero "<html>\n";
print fichero "<body bgcolor=\#f1f1f1>\n";
print fichero "<center>Esta es tu pagina web principal\n aquí podrá crear los contenidos que desee.</center>\n";
print fichero "</body>";
print fichero "</html>\n";

close(fichero);

#chown "$usuario","www-data", "/var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario/index.html";
chmod (0755, " /var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario/meter_aqui_tus_paginas_webs/index.html");
system("sudo chown $usuario:clientes /var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario/meter_aqui_tus_paginas_webs/index.html");

chmod (0755, " /var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario/meter_aqui_tus_paginas_webs");
system("sudo chown $usuario:clientes /var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario/meter_aqui_tus_paginas_webs");

if($registradoAnterior==0) { #Si es 0 no estaba registrado anteriormente
	open (fichero ,">> /etc/ssh/sshd_config") || die "No pudo abrirse: $!";
	print fichero "\nMatch User $usuario\nChrootDirectory /var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario\nForceCommand internal-sftp -l INFO\nAllowTcpForwarding no\nX11Forwarding no\n\n";
	close (fichero);

	my $file = '/etc/rsyslog.d/sftp.conf';  # Especifica la ruta del archivo
	my $cadena = qq{input(type="imuxsock" Socket="/var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario/dev/log" CreatePath="on")};  # Cadena que deseas insertar

	# Leer el contenido del archivo
	open(my $fh, '<', $file) or die "No se pudo abrir el archivo: $!";
	my @lineas = <$fh>;
	close($fh);

	# Insertar la cadena en la segunda línea
	splice(@lineas, 1, 0, $cadena . "\n");
	
	# Escribir el contenido modificado en el archivo
	open($fh, '>', $file) or die "No se pudo abrir el archivo para escribir: $!";
	print $fh @lineas;
	close($fh);


	my $sentencia2 = $dbh->prepare('update usuario set creadoWeb=1 where nombreUsuario=?');
	$sentencia2->execute($usuario);
}

chmod (0755, "/var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario");
system("sudo chown root:root /var/www/GarciaPozoIT/paginasWebUsuarios/webs_$usuario");

system("sudo chown root:root /var/www/GarciaPozoIT/paginasWebUsuarios");
my $servicio = 'ssh';

system("sudo systemctl restart $servicio");

$servicio = 'rsyslog';

system("sudo systemctl restart $servicio");

my $sentencia1 = $dbh->prepare('update usuario set web=1 where nombreUsuario=?');
$sentencia1->execute($usuario);

print $cgi->header(-location=>"http://192.168.1.89/cgi-bin/serviciosUsuario.pl");

exit(0);
