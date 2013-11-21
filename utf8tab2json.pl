#!C:\strawberry\perl\bin\perl.exe 
use strict;
use warnings;
use JSON;
use Digest::SHA qw(sha1_hex);
use Encode;
use Data::Dumper;
binmode STDOUT;
binmode STDIN;
undef $/;

my $json = JSON->new->pretty;
my $file = <>;
my @alunos = split /\n/, $file;

my $data = openJSON('file.json');

foreach(@alunos){
	my ($nome,$email,$grupo) = split /\t/;
	next unless defined $grupo and $grupo =~ /T/;
	my $id = sha1_hex($nome, $email, $grupo, 5470);
	my $n = sha1_hex($nome, $email, $grupo, 0745);
	$data->{alunos}->{$id} = {
		email => $email,
		nome => $nome,
		grupo => $grupo
	};
	$data->{grupos}->{$grupo}->{$id} = {
		email => $email,
		nome => $nome, 
	};
	my $c = 0;
	foreach (sort keys %{$data->{grupos}->{$grupo}}){
		$c++;
		last if $_ eq $id;
	};
	$data->{grupos}->{$grupo}->{$id}->{number} = $c;
}
print $json->encode($data);
saveJSON('file.json',$data);
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
sub saveJSON{
	my ($file,$ref) = @_;
	eval{
		open my $f, '>:raw', $file or die "Cannot open $file";
		#open my $f, '>', "$file" or die "Cannot open $file";
		#binmode $f;
		print $f $json->encode($ref);
		close $f;
	};
	warn $@ if $@;
	return 1;
}
#print Dumper \%alunos; 
#print Dumper \%grupos; 
#print @alunos;


#print $file;