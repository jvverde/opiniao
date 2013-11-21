#!C:\strawberry\perl\bin\perl.exe 
use strict;
use warnings;
use JSON;
use Digest::SHA qw(sha1_hex);
use Encode;
use Data::Dumper;
binmode STDOUT;
binmode STDIN;
use Net::SMTP;
use utf8;
use Encode;
use MIME::Entity;

undef $/;


my $json = JSON->new->pretty;
my @dayofweek = (qw(Sun Mon Tue Wed Thur Fri Sat));
my @monthnames = (qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec));
sub prepara{
	my ($data,$sender,$to,$subject) = @_;
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime();
	$year += 1900;
    my $Date = sprintf("%s, %02d %3s %04d %02d:%02d:%02d GMT",$dayofweek[$wday],$mday,$monthnames[$mon],$year,$hour,$min,$sec);
	my $entity = MIME::Entity->build(
		Type => "text/plain",
		Charset => "UTF-8",
		Encoding => "quoted-printable",
		Data => Encode::encode( "UTF-8", $data ),
		From => Encode::encode(
			"MIME-Header", $sender
		),
		To => Encode::encode(
			"MIME-Header", $to
		),
		Subject => Encode::encode(
			"MIME-Header", $subject
		),
		Date => $Date
	);
	return $entity->stringify;
}
my $data = openJSON('file.json');
foreach (keys %{$data->{alunos}}){
	my $aluno = decode('utf8' => $data->{alunos}->{$_}->{nome});
	my $email = $data->{alunos}->{$_}->{email};
	my $grupo = $data->{alunos}->{$_}->{grupo};
	my $link = "http://gnomo.fe.up.pt/~jvv/tmp/ltw/votar.php?id=$_";
	
	my $msg = qq|Caro $aluno,
	
Use o link $link para dar a sua opinião sobre a participação relativa de cada 
elemento do seu grupo ($grupo) nesta primeira entrega do trabalho de LTW

Note que esta informação é secreta, mas não anónima. 
Não partilhe o link com mais ninguém, sobe pena de a sua opinião poder ser 
alterada por quem conheça o link.

Também pode posteriormente alterar a sua opinião acedendo novamente ao mesmo link

Obrigado

Isidro Vila Verde
|;
	#$email = 'jvverde@gmx.com';
	my $smtp = Net::SMTP->new('smtp.fe.up.pt', Port=> 25, Timeout => 10, Debug => 1) or die "Could not connect to server!\n";
	$smtp->hello('fe.up.pt');
	$smtp->mail('jvv@fe.up.pt');
	$smtp->to($email);
	$smtp->bcc('jvverde@gmail.com');
	$smtp->data();
	$smtp->datasend(prepara(
		$msg,
		'jvv@fe.up.pt',
		$email,
		"Participação de cada elemento do grupo $grupo de LTW"
	));
	$smtp->dataend();
	$smtp->quit();
}


sub openJSON{
	my ($file) = @_;
	return {} unless -r $file;
	my $result = {};
	eval{
		local $/;
		open my $f, '<:raw', "$file" or die "Cannot open $file";
		#open my $f, '<', "$file" or die "Cannot open $file";
		#binmode $f;
		my $json_text   = <$f>;
		close $f;
		$result = $json->decode( $json_text );
	};
	warn $@ if $@;
	return $result;  
}