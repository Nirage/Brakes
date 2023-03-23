<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>Check Status &middot; hybris</title>
		<script src="/authorizationserver/static/js/common.js"></script>
	</head>
	<body>
	You have logged in successfully. This page will reload. 
	<script type="application/javascript">
		if (inIframe()) {
			parent.postMessage({ type: 'SSO_AUTHORIZATION_TYPE', msg: '${status}'}, "*");
		} else {
			// We need to add the dynamic login here for ticket BRAKESP2-3520
			const location = window.location;
			location.href = location.protocol+ '//' + location.host;
		}
	</script>
	</body>
</html>