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
			
			form.loginPw.value = form.loginPw.value.trim();
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
					<span>UNTACT</span>
				</a>
			</div>

			<div class="section-member-login">
				<div class="container mx-auto mt-4">
					<div class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

							<form class="bg-white w-full shadow-md rounded px-8 pt-6 pb-8"
								action="doLogin" method="POST"
								onsubmit="LoginForm__checkAndSubmit(this); return false;">
								<input type="hidden" name="redirectUrl"
									value="${param.redirectUrl}" />


								<div class="form-control">
									<input name="loginId" autofocus="autofocus" type="text"
										placeholder="아이디를 입력해주세요." class="input input-bordered"
										maxlength="20">
								</div>

								<div class="form-control mt-3 mb-4">
									<input name="loginPw" autofocus="autofocus" type="password"
										placeholder="비밀번호를 입력해주세요." class="input input-bordered"
										maxlength="20">
								</div>
								
								<div class="form-control mb-2">
									<input type="submit" class="btn btn-wide btn-sm mb-1 bg-gray-400 border-transparent w-full" value="회원가입">
								</div>
								
								<div class="flex flex-col md:flex-row">
									<div class="p-1 text-center md:flex-grow">
										<a href="join" class="text-gray-600 inline-block hover:underline">회원가입</a>
										<a href="#" class="text-gray-600 inline-block hover:underline"> | </a>
										<a href="#" class="text-gray-600 inline-block hover:underline">아이디찾기</a>
										<a href="#" class="text-gray-600 inline-block hover:underline"> | </a>
										<a href="#" class="text-gray-600 inline-block hover:underline">비밀번호찾기</a>
									</div>
								</div>
							</form>

						</div>
					</div>
				</div>
			</div>
		</div>


</section>

<%@ include file="../part/foot.jspf"%>
