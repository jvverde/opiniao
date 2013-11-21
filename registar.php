<?php
ob_start();
?>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>LTW participação</title>
		<link rel="stylesheet" href="style.css" type="text/css">
	</head>
	<body>
		<div>
<?php
		if ($w = $_GET[w]){
			$json = json_decode(file_get_contents('file.json'),true);
			if($aluno = $json[alunos][$w]){
				$r = array();
				$soma = 0;
				foreach($json[grupos][$aluno[grupo]] as $g => $a){
					$n = $a[number];
					$soma += $r[$g]=$_GET["n$n"];	
				}
				if ($soma != 100){
					header("Location:./votar.php?id=$w&erro=O valor total deve ser 100%");
				}else{
					$obj['ip'] = $_SERVER[REMOTE_ADDR];
					$obj['time'] = strftime("%Y-%m-%dT%H:%M:%S",time());
					$obj[voto] = $r;
					$obj[id] = $w;
					$obj[nome] = $aluno[nome];
					$obj[coment] = $_GET[coment];
					file_put_contents('./data/'.$w.".json", json_encode($obj));
					header("Location:./votar.php?id=$w&msg=Dados submetidos com sucesso. Obrigado!");
				}
			}else{
				echo 'Identificador inválido';
			}
		}else{
			echo 'Acesso ilegal';
		}
?>
		</div>
	</body>
</html>