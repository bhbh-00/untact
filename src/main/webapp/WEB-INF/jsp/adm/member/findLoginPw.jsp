<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../part/head.jspf"%>

<!-- sha256 -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<script>
	<!--  자바스크립트  -->
		const findLoginPw__checkAndSubmitDone = false;
		<!--  const = var / 중복 방지를 위한.  -->
		function findLoginPw__checkAndSubmit(form) {
			if ( findLoginPw__checkAndSubmitDone ) {
				return;
			}
		
			form.loginId.value = form.loginId.value.trim();

			if ( form.loginId.value.length == 0 ) {
				alert('아이디를 입력해주세요.');
				form.loginId.focus();
				
				return;
			}
			
			form.email.value = form.email.value.trim();
			
			if ( form.email.value.length == 0 ) {
				alert('이메일을 입력해주세요.');
				form.email.focus();
				
				return;
			}
			
			form.submit();
			findLoginPw__checkAndSubmitDone = true;
		}
		
	
	</script>
<section class="section-usr-findLoginPw">

	<div
		class="container mx-auto min-h-screen flex items-center justify-center">
		<div class="w-full">
			<div class="logo-bar flex justify-center mt-3">
				<a href="login" class="logo">
					<span>
						<i class="fas fa-people-arrows"></i>
					</span>
					<span>UNTACT ADMIN</span>
				</a>
			</div>

			<div class="section-member-findLoginPw">
				<div class="container mx-auto mt-4">
					<div
						class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

						<form class="bg-white w-full shadow-md rounded px-8 pt-6 pb-8"
							action="doFindLoginPw" method="POST"
							onsubmit="findLoginPw__checkAndSubmit(this); return false;">

							<input type="hidden" name="redirectUrl"
								value="${param.redirectUrl}" />

							<div class="container mx-auto flex mb-4 text-xl">
								<span class="flex items-center mr-1">
									<i class="fas fa-search"></i>
								</span>
								<span class="font-bold"> 비밀번호 찾기 </span>
							</div>

							<div class="form-control">
								<span class="p-1">이름</span>
								<input name="name" autofocus="autofocus" type="text"
									placeholder="이름을 입력해주세요." class="input input-bordered"
									maxlength="20">
							</div>

							<div class="form-control mt-3">
								<span class="p-1">아이디</span>
								<input name="loginId" autofocus="autofocus" type="text"
									placeholder="아이디를 입력해주세요." class="input input-bordered"
									maxlength="20">
							</div>

							<div class="form-control mt-3 mb-4">
								<span class="p-1">이메일</span>
								<input name="email" autofocus="autofocus" type="email"
									placeholder="이메일를 입력해주세요." class="input input-bordered"
									maxlength="100">
							</div>

							<div class="form-control mb-2">
								<input type="submit"
									class="btn btn-wide btn-sm mb-1 bg-gray-400 border-transparent w-full"
									value="찾기">
							</div>

							<div class="flex flex-col md:flex-row text-gray-600">
								<div class="p-1 text-center md:flex-grow">									
									<i class="fas fa-sign-in-alt"></i>
									<a href="login"
										class="inline-block hover:underline">로그인</a>
									<a href="#" class="inline-block hover:underline">
										| </a>
									<i class="fas fa-user"></i>
									<a href="join"
										class="inline-block hover:underline">회원가입</a>
									<a href="#" class="inline-block hover:underline">
										| </a>
									<i class="fas fa-search"></i>
									<a href="findLoginId"
										class="inline-block hover:underline">아이디찾기</a>
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
