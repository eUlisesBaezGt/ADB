<html>
	<body>
		<font face="Arial">
<?php

	error_reporting(E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED);
	ini_set("display_errors", 1);
		
	$conn = mysqli_connect("localhost", "root", "", "vulnerable");
	if ($conn) {
		//if (mysqli_select_db("vulnerable")) {

			$lID = array_key_exists('id', $_REQUEST) == true ? $_REQUEST['id'] : '';
			if ($lID != '') {
				$lID = intval($lID);
				$sql = "SELECT * FROM users WHERE id = $lID";
				$result = mysqli_query($conn, $sql);
				if ($result) {
					if (mysqli_num_rows($result) > 0) {
						while ($row = mysqli_fetch_assoc($result)) {
							echo "Login: {$row["login"]}, Correo: {$row["email"]} <br><br>\n";
						}
					}
					mysqli_free_result($result);
				}
			}
			
			$lLogin = array_key_exists('login', $_REQUEST) == true ? $_REQUEST['login'] : '';
			$lEMail = array_key_exists('email', $_REQUEST) == true ? $_REQUEST['email'] : '';
			$lPswd  = array_key_exists('pswd', $_REQUEST) == true ? $_REQUEST['pswd'] : '';

            $lEMail = str_replace('<', '&lt;', $lEMail);
			$lEMail = str_replace('>', '&gt;', $lEMail);

			if ( ($lLogin != '') && ($lEMail != '') && ($lPswd != '') ) {
				$sql = "INSERT INTO users (login,email,pswd) VALUES('$lLogin','$lEMail','$lPswd')";
				$result = mysqli_query($conn, $sql);
				
				$sql = "SELECT id FROM users WHERE login='$lLogin' AND email='$lEMail' AND pswd='$lPswd'";
				$result = mysqli_query($conn, $sql);
				if ($result) {
					if (mysqli_num_rows($result) > 0) {
						$row = mysqli_fetch_assoc($result);
						echo "ID: {$row["id"]} <br><br>\n";
					}
					mysqli_free_result($result);
				}
			}
			
		//}
		mysqli_close($conn);
	}
?>
			<br><hr><br>
			
			<form name="frmShowUser" action="usuarios.php" method="post">
				ID: <input name="id" id="id" type="text" value="" /><br><br>
				<input name="send" id="send" type="submit" value="Mostrar" />
			</form>
			
			<br><hr><br>
			
			<form name="frmAddUser" action="usuarios.php" method="post">
				Login: <input name="login" id="login" type="text" value="" /><br><br>
				Email: <input name="email" id="email" type="text" value="" /><br><br>
				Contrase&ntilde;a: <input name="pswd" id="pswd" type="password" value="" /><br><br>
				<input name="send" id="send" type="submit" value="Ejecutar Alta" />
			</form>
			
		</font>
	</body>
</html>
