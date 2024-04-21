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
use IO::All;

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
$sentencia1->execute(3);
while(($usuario,$nombre,$apellidos,$correo) = $sentencia1->fetchrow()){

	my $transport = Email::Sender::Transport::SMTPS->new(
		host => 'smtp.gmail.com',
   		port => 587,
		ssl  => 'starttls',
  		sasl_username => 'registrogarciapozoit1@gmail.com',
   		sasl_password => 'fbnxurnqgxxckzmf',
		debug => 0, # or 1
	);

	my $transport = Email::Sender::Transport::SMTPS->new(
                host => 'smtp.gmail.com',
                port => 587,
                ssl  => 'starttls',
                sasl_username => 'registrogarciapozoit1@gmail.com',
                sasl_password => 'fbnxurnqgxxckzmf',
                debug => 0, # or 1
        );

	my $archivo_zip = '/home/estadisticas/estadisticas.zip';

	my $contenido_zip = io($archivo_zip)->all();

	my $message;

        $message = Email::MIME->create(
                header_str => [
                        From    => 'registrogarciapozoit1@gmail.com',
                        To      => $correo,
                        Subject => 'Estadisticas GarciaPozo IT',
                ],
                attributes => {
                        charset =>'UTF-8',
                },
                parts => [
			Email::MIME->create(
				attributes => {
					content_type => 'application/zip',
					disposition => 'attachment',
					filename => 'estadisticas.zip',
					name => 'estadisticas.zip',
				},
				body => $contenido_zip, 
			),

		],
        );

        try {
                sendmail($message, { transport => $transport });
        } catch {
                die "Error sending email: $_";
        };


	#$message->send('smtp', Port => 587, SSL=>1, AuthUser=>'registrogarciapozoit1@gmail.com', AuthPass=>'fbnxurnqgxxckzmf', debug => 0);
	try {
                sendmail($message, { transport => $transport });
        } catch {
                die "Error sending email: $_";
        };

}

$dbh->disconnect();
exit(0);
