<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 로그인 페이지</title>
</head>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.0.3/tailwind.min.css" />
<body>
	<script>
	<!--  자바스크립트  -->
		const LoginForm__checkAndSubmitDone = false;
		<!--  const = var / 중복 방지를 위한.  -->
		function LoginForm__checkAndSubmit(form) {
			if ( LoginForm__checkAndSubmitDone ) {
				return;
			}
		
			form.loginId.value = form.loginId.value.trim();
			<!--  trim() : 공백 감지  -->
			if ( form.loginId.value.length == 0 ) {
				alert('아이디를 입력해주세요.');
				form.loginId.focus();
				
				return;
			}
			
			if ( form.loginPw.value.length == 0 ) {
				alert('비밀번호를 입력해주세요.');
				form.loginPw.focus();
				
				return;
			}
			
			form.submit();
			LoginForm__checkAndSubmitDone = true;
		}
	</script>
	<section class="section-login">
		<div class="container mx-auto">
		<!--  mx-auto : margin: 0 auto;  -->
			<form action="doLogin" method="POST" onsubmit="LoginForm__checkAndSubmit(this); return false;">
				<div class="flex">					
					<div class="flex-grow p-4">
					<!--  flex-grow : 가능한 공간을 채우기 위해 플렉스 항목을 확장하는 데 사용 / p : padding -->
						<input class="w-full" autofocus="autofocus" type="text"
							placeholder="아이디" name="loginId" maxlength="20" />
						<!--  w-full : 폭 넓이 전체 / autofocus : 자동 포커스  -->
					</div>
				</div>
				<div class="flex">
					<div class="flex-grow p-4">
						<input class="w-full" autofocus="autofocus" type="password"
							placeholder="비밀번호" name="loginPw" maxlength="20" />
					</div>
				</div>
				<div class="flex">
					<div class="flex-grow p-4">
						<input class="w-full" type="submit" value="로그인" />
					</div>
				</div>
			</form>
		</div>
	</section>

</body>
</html>