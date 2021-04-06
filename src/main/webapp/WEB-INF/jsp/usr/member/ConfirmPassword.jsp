<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<script>
	<!--  자바스크립트  -->
		const ConfirmPasswordForm__checkAndSubmitDone = false;
		<!--  const = var / 중복 방지를 위한.  -->
		function ConfirmPasswordForm__checkAndSubmit(form) {
			if ( ConfirmPasswordForm__checkAndSubmitDone ) {
				return;
			}
			
			form.loginPw.value = form.loginPw.value.trim();
			if ( form.loginPw.value.length == 0 ) {
				alert('비밀번호를 입력해주세요.');
				form.loginPw.focus();
				
				return;
			}
			
			form.submit();
			ConfirmPasswordForm__checkAndSubmitDone = true;
		}
		
	
	</script>
<section class="section-login">
	<div class="container mx-auto min-h-screen flex justify-center">
		<div class="w-full">
			<div class="logo-bar flex justify-center mt-3">
				<a href="#" class="logo">
					<span>
						<i class="fas fa-people-arrows"></i>
					</span>
					<span>MY INFO</span>
				</a>
			</div>
			
			<form class="bg-white w-full shadow-md rounded px-8 pt-6 pb-8" action="doConfirmPassword" method="POST" onsubmit="ConfirmPasswordForm__checkAndSubmit(this); return false;">
				<input type="hidden" name="redirectUrl" value="${param.redirectUrl}" />
				
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input class="shadow appearance-none border border-red rounded w-full py-2 px-3 text-grey-darker mb-3"
							autofocus="autofocus" type="password" placeholder="비밀번호" name="loginPw" maxlength="20" />
					</div>
				</div>
				
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input class="w-full btn-primary bg-gray-400 hover:bg-gray-200 text-white font-bold py-2 px-4 rounded"
							type="submit" value="확인" />						
					</div>
				</div>
				
				<div class="flex flex-col md:flex-row">
					<div class="p-1 text-center md:flex-grow">
						<a href="#" class="text-gray-600 inline-block hover:underline">비밀번호찾기</a>
						<a href="#" class="text-gray-600 inline-block hover:underline">|</a>
						<a href="#" class="text-gray-600 inline-block hover:underline">취소</a>
					</div>
				</div>
			</form>

		</div>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
