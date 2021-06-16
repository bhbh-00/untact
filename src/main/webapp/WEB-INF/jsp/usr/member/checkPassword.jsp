<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<!-- sha256 -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<script>
	const checkPasswordForm__checkAndSubmitDone = false;

	function checkPasswordForm__checkAndSubmit(form) {
		if (checkPasswordForm__checkAndSubmitDone) {
			return;
		}

		form.loginPwInput.value = form.loginPwInput.value.trim();
		if (form.loginPwInput.value.length == 0) {
			alert('비밀번호를 입력해주세요.');
			form.loginPwInput.focus();

			return;
		}

		form.loginPw.value = sha256(form.loginPwInput.value);
		form.loginPwInput.value = '';

		form.submit();
		checkPasswordForm__checkAndSubmitDone = true;
	}
</script>

<section class="section-checkPassword">

	<div class="section-member-checkPassword">
		<div class="container mx-auto mt-4 mb-5">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

				<div class="px-4 py-4">

					<div class="container mx-auto flex mb-2 ml-2 text-xl">
						<span class="flex items-center mr-1">
							<i class="fas fa-user-cog"></i>
						</span>
						<span class="font-bold"> 마이페이지 </span>
					</div>

					<form class="grid form-type-1" action="doCheckPassword"
						method="POST"
						onsubmit="checkPasswordForm__checkAndSubmit(this); return false;">

						<input type="hidden" name="checkPasswordAuthCode"
							value="${param.checkPasswordAuthCode}">
						<input type="hidden" name="loginPw" />

						<div class="form-control">
							<input name="loginPwInput" type="password"
								placeholder="비밀번호를 입력해주세요." class="input input-bordered"
								maxlength="30">
						</div>

						<div class="flex flex-col mb-2 md:flex-row">
							<div class="p-1 md:flex-grow">
								<input
									class="w-full btn-primary bg-gray-400 hover:bg-gray-200 text-white font-bold py-2 px-4 rounded"
									type="submit" value="확인" />
							</div>
						</div>

						<div class="flex flex-col md:flex-row">
							<div class="p-1 text-center md:flex-grow">
								<a href="findLoginPw"
									class="text-gray-600 inline-block hover:underline">비밀번호 찾기</a>
							</div>
						</div>
					</form>

				</div>
			</div>


		</div>
	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
