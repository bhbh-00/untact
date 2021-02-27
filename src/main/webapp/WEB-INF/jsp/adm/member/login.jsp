<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../part/head.jspf"%>

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
	<div class="container mx-auto min-h-screen flex items-center justify-center">
		<div class="w-full">
			<div class="logo-bar flex justify-center mt-3">
				<a href="#" class="logo">
					<span>
						<i class="fas fa-people-arrows"></i>
					</span>
					<span>UNTACT ADMIN</span>
				</a>
			</div>
			<form class="bg-white w-full shadow-md rounded px-8 pt-6 pb-8" action="doLogin" method="POST"
				onsubmit="LoginForm__checkAndSubmit(this); return false;">
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
							autofocus="autofocus" type="text" placeholder="아이디" name="loginId" maxlength="20" />
					</div>
				</div>
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input class="shadow appearance-none border border-red rounded w-full py-2 px-3 text-grey-darker mb-3"
							autofocus="autofocus" type="text" placeholder="비밀번호" name="loginPw" maxlength="20" />
					</div>
				</div>
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input class="w-full bg-blue-300 hover:bg-blue-400 text-white font-bold py-2 px-4 rounded"
							type="submit" value="로그인" />
					</div>
				</div>
			</form>

		</div>
	</div>
</section>

<%@ include file="../part/foot.jspf"%>
