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
	if ($id = $_GET[id]){
		$json = json_decode(file_get_contents('file.json'),true);
		if($aluno = $json[alunos][$id]){
?>
			<form action="registar.php" method="get">
			<input type="hidden" name="w" value="<?=$id?>">
			<table>
				<thead>
					<tr><td colspan="2">Participação relativa dos elementos do grupo <?=$aluno[grupo]?> de LTW</td></tr> 
					<tr><td colspan="2">Opinião de <?=$aluno[nome]?></td></tr> 
				</thead>
				<tfoot>
					<?php if($_GET[erro]) echo '<tr><td>Erro na submissão: <span  class="error">'.$_GET[erro].'</span></td></tr>' ?>
					<?php if($_GET[msg]) echo '<tr><td><span  class="ok">'.$_GET[msg].'</span></td></tr>' ?>
					<tr><td colspan="2"><input type="submit" value="Enviar"></td></tr>
				</tfoot>	
				<tbody>
<?php
				$filename = dirname(__FILE__) . "/data/$id" . '.json';
				if (file_exists($filename)) $old = json_decode(file_get_contents($filename),true);
				foreach($json[grupos][$aluno[grupo]] as $g => $a){
					$v = '';
					if (isset($old)){
						$v = $old[voto][$g];
					}
					echo '<tr><td>';	
					echo $a[nome];
					echo "</td><td><input size='2' type='text' value='$v' required pattern='\d{1,2}' name='n$a[number]'>%";
						
					echo '</td></tr>';	
					
				}
				$coment = isset($old) ? $old[coment]: "";
?>	
					<tr><td colspan="2" class="coment">Comentário (opcional)<br>
						<textarea 
							placeholder="Use este campo se quiser adicionar alguma informação adicional sobre o desenvolvimento do trabalho" 
							rows="4" name="coment" maxlength="200"><?=$coment?></textarea>
					</td></tr>
				</tbody>
			</table>
			</form>

<?php	
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
