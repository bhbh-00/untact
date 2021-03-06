<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../part/head.jspf"%>

<script>
const JoinForm__checkAndSubmitDone = false;
<!--  const = var / 중복 방지를 위한.  -->
function JoinForm__checkAndSubmit(form) {
	if ( JoinForm__checkAndSubmitDone ) {
		return;
	}
	form.loginId.value = form.loginId.value.trim();
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
	
	form.loginPwConfirm.value = form.loginPwConfirm.value.trim();
	if ( form.loginPwConfirm.value.length == 0 ) {
		alert('비밀번호를 확인해주세요.');
		form.loginPwConfirm.focus();
		
		return;
	}
	
	form.name.value = form.name.value.trim();
	if ( form.name.value.length == 0 ) {
		alert('이름을 입력해주세요.');
		form.name.focus();
		
		return;
	}
	
	form.nickname.value = form.nickname.value.trim();
	if ( form.nickname.value.length == 0 ) {
		alert('닉네임를 입력해주세요.');
		form.nickname.focus();
		
		return;
	}
	
	form.email.value = form.email.value.trim();
	if ( form.email.value.length == 0 ) {
		alert('이메일를 입력해주세요.');
		form.email.focus();
		
		return;
	}
	
	form.cellphoneNo.value = form.cellphoneNo.value.trim();
	if ( form.cellphoneNo.value.length == 0 ) {
		alert('전화번호를 입력해주세요.');
		form.cellphoneNo.focus();
		
		return;
	}
				
	form.submit();
	JoinForm__checkAndSubmitDone = true;
}
</script>

<section class="section-Join">
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

			<form class="bg-white w-full shadow-md rounded px-8 pt-6 pb-8" action="doJoin" method="POST" onsubmit="JoinForm__checkAndSubmit(this); return false;">
				<input type="hidden" name="redirectUrl" value="${param.redirectUrl}" />

				<!-- loginId -->
				<div class="flex flex-col mt-4 ml-4 md:flex-row">
					<div class="md:w-36 md:flex md:items-center">						
						<span>아이디</span>
					</div>
				</div>
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker" autofocus="autofocus" type="text" name="loginId" maxlength="20" />
					</div>
				</div>

				<!-- loginPw -->
				<div class="flex flex-col ml-4 md:flex-row">
					<div class="md:w-36 md:flex md:items-center">	
						<span>비밀번호</span>
					</div>
				</div>
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker" autofocus="autofocus" type="password" placeholder="영문+숫자 조합으로 입력해주세요." name="loginPw" maxlength="20" />
					</div>
				</div>

				<!-- loginPw 확인 -->
				<div class="flex flex-col ml-4 md:flex-row">
					<div class="md:w-36 md:flex md:items-center">	
						<span>비밀번호 확인</span>
					</div>
				</div>
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
					<input class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker" autofocus="autofocus" type="password" name="loginPwConfirm" maxlength="20" />
					</div>

				</div>

				<!-- name -->
				<div class="flex flex-col ml-4 md:flex-row">
					<div class="md:w-36 md:flex md:items-center">	
						<span>이름</span>
					</div>
				</div>
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker" autofocus="autofocus" type="text" placeholder="ex) 홍길동" name="name" maxlength="20" />
					</div>
				</div>

				<!-- nickname -->
				<div class="flex flex-col ml-4 md:flex-row">
					<div class="md:w-36 md:flex md:items-center">	
						<span>닉네임</span>
					</div>
				</div>
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
							autofocus="autofocus" type="text" placeholder=""
							name="nickname" maxlength="20" />
					</div>
				</div>

				<!-- email -->
				<div class="flex flex-col ml-4 md:flex-row">
					<div class="md:w-36 md:flex md:items-center">	
						<span>이메일</span>
					</div>
				</div>
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
							autofocus="autofocus" type="text" placeholder="@untact.com"
							name="email" maxlength="100" />
					</div>
				</div>

				<!-- cellphoneNo -->
				<div class="flex flex-col ml-4 md:flex-row">
					<div class="md:w-36 md:flex md:items-center">	
						<span>전화번호</span>
					</div>
				</div>
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
							autofocus="autofocus" type="tel" placeholder="-는 제외해주세요. ex) 01000000000"
							name="cellphoneNo" maxlength="11" />
					</div>
				</div>

				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input class="btn-primary bg-gray-400 text-white font-bold py-2 px-4 rounded" type="submit" value="회원가입" />	
						<input onclick="history.back();" type="button" class="btn-info bg-red-500 text-white font-bold py-2 px-4 rounded" value="취소">	
					</div>
				</div>
			</form>

		</div>
	</div>
</section>

<%@ include file="../part/foot.jspf"%>
