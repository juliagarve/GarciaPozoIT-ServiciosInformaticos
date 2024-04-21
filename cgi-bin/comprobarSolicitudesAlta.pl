#!/usr/bin/perl

use CGI;
use strict;
use DBI;
use POSIX qw/ strftime /;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTPS;
use Try::Tiny;
use Email::MIME;
use utf8;
use Template;

my $cgi= new CGI;

my $nombre;
my $apellidos;
my $correo;
my $usuario;

my $database = 'DBgarciapozoit';
my $host = 'localhost';
my $username = 'admin';
my $password = 'labii';

my $dbh = DBI->connect("DBI:MariaDB:database=$database;host=$host",$username,$password,{RaiseError=>1,PrintError=>0});

my $sentencia1 = $dbh->prepare('select nombreUsuario,nombre,apellido,direccionC from usuario where estado=?');
$sentencia1->execute(1);
while(($usuario,$nombre,$apellidos,$correo) = $sentencia1->fetchrow()){

	my $template = Template->new({ENCODING => 'utf8',});
	my $var;
	$var->{nombre_usuario}=$usuario;
	$var->{clave}=int(rand(900000))+100000;
        my $salida;
        $template->process('correoConfirmacion.html',$var,\$salida);


	my $sentencia3 = $dbh->prepare('update usuario set clave=? where nombreUsuario=?');
	$sentencia3->execute($var->{clave},$usuario);
	
	my $transport = Email::Sender::Transport::SMTPS->new(
		host => 'smtp.gmail.com',
   		port => 587,
		ssl  => 'starttls',
  		sasl_username => 'registrogarciapozoit1@gmail.com',
   		sasl_password => 'fbnxurnqgxxckzmf',
		debug => 0, # or 1
	);

	my $message = Email::MIME->create(
		header_str => [
	      		From    => 'registrogarciapozoit1@gmail.com',
        		To      => $correo,
        		Subject => 'Confirma tu cuenta en GarciaPozo IT',
    		],
		attributes => {
			charset =>'UTF-8',
			encoding => 'quoted-printable',
			content_type => 'text/html',
		},
   		body_str => $salida,
	);
 
	try {
		sendmail($message, { transport => $transport });
	} catch {
		die "Error sending email: $_";
	};
	my $sentencia2 = $dbh->prepare('update usuario set estado=2 where nombreUsuario=?');
	$sentencia2->execute($usuario);
}

$dbh->disconnect();
exit(0);
