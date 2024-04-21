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

# Posibles contenidos html a insertar

my $correoNo = <<'HTML';
<li class="w3-padding-16">
        <i class="fa fa-envelope fa-fw w3-margin-right pb-2" style="width:35px"></i>
        <span class="w3-xlarge">Correo electrónico</span>
	<button type="button" class="w3-right w3-button w3-dark-grey" data-toggle="modal" data-target="#confirmacionContratarCorreo">Contratar <i class="fa fa-arrow-right"></i></button>
</li>
HTML

my $blogNo = <<'HTML';
<li class="w3-padding-16">
        <i class="fa fa fa-pencil-square-o fa-fw w3-margin-right pb-2" style="width:35px"></i>
	<span class="w3-xlarge">Blog</span>
        <button class="w3-right w3-button w3-dark-grey" data-toggle="modal" data-target="#confirmacionContratarBlog">Contratar <i class="fa fa-arrow-right"></i></button><br>
</li>
HTML

my $webNo = <<'HTML';
<li class="w3-padding-16">
        <i class="fa fa-globe fa-fw w3-margin-right pb-2" style="width:35px"></i>
        <span class="w3-xlarge">Albergue de páginas WEB</span>
        <button class="w3-right w3-button w3-dark-grey" data-toggle="modal" data-target="#confirmacionContratarWEB">Contratar <i class="fa fa-arrow-right"></i></button><br>
</li>
HTML

my $correoSi = <<'HTML';
<li class="w3-padding-16">
        <i class="fa fa-envelope fa-fw w3-margin-right pb-2" style="width:35px"></i>
        <span class="w3-xlarge">Correo electrónico</span>
        <button type="button" class="w3-right w3-button w3-dark-grey" data-toggle="modal" data-target="#confirmacionEliminarCorreo">Finalizar <i class="fa fa-arrow-right"></i></button>
</li>
HTML

my $blogSi = <<'HTML';
<li class="w3-padding-16">
        <i class="fa fa fa-pencil-square-o fa-fw w3-margin-right pb-2" style="width:35px"></i>
        <a href="https://192.168.1.89/wordpress/wp-login.php" target="_blank">
	        <span class="w3-xlarge">Blog</span>
	</a>
        <button class="w3-right w3-button w3-dark-grey" data-toggle="modal" data-target="#confirmacionEliminarBlog">Finalizar <i class="fa fa-arrow-right"></i></button><br>
</li>
HTML

my $webSi = <<'HTML';
<li class="w3-padding-16">
        <i class="fa fa-globe fa-fw w3-margin-right pb-2" style="width:35px"></i>
        <span class="w3-xlarge">Albergue de páginas WEB</span>
        <button class="w3-right w3-button w3-dark-grey" data-toggle="modal" data-target="#confirmacionEliminarWEB">Finalizar <i class="fa fa-arrow-right"></i></button><br>
</li>
HTML


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

	my $correo;
	my $blog;
	my $web;
	my $insertar;

	my $database = 'DBgarciapozoit';
	my $host = 'localhost';
	my $username = 'admin';
	my $password = 'labii';

	my $dbh = DBI->connect("DBI:MariaDB:database=$database;host=$host",$username,$password,{RaiseError=>1,PrintError=>0});

	my $sentencia1 = $dbh->prepare('select correo,blog,web from usuario where nombreUsuario=?');
	$sentencia1->execute($usuario);
	if(($correo,$blog,$web) = $sentencia1->fetchrow()){
	
		$dbh->disconnect();
		
		$insertar->{nombre_usuario}=$usuario;		

		if($correo == 0){
			$insertar->{correo_si}="";
			$insertar->{correo_no}=$correoNo;
		}else{
			$insertar->{correo_si}=$correoSi;
                        $insertar->{correo_no}="";
		}

		if($blog == 0){
			$insertar->{blog_si}="";
                        $insertar->{blog_no}=$blogNo;
                }else{
                        $insertar->{blog_si}=$blogSi;
                        $insertar->{blog_no}="";
                }

		if($web == 0){
                        $insertar->{web_si}="";
                        $insertar->{web_no}=$webNo;
                }else{
                        $insertar->{web_si}=$webSi;
                        $insertar->{web_no}="";
                }

		my $plantilla = Template->new({ENCODING => 'utf8',});
		my $output;
        	$plantilla->process('plantillaServiciosUsuario.html',$insertar,\$output);
        	print $cgi->header(-charset =>'UTF-8');
		print $output;
	}
	exit(0);

