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

	<div class="section-article-write">
		<div class="container mx-auto">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">
				<div class="card-title bg-gray-400 text-white">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>마이페이지</span>
				</div>

				<div class="px-4 py-8">

					<form class="grid form-type-1" action="doConfirmPassword"
						method="POST"
						onsubmit="ConfirmPasswordForm__checkAndSubmit(this); return false;">

						<div class="form-control">
							<label class="label">
								<span class="label-text">${member.loginId}<span>
							</label>
						</div>
						<div class="form-control py-4">
							<input name="loginPw" type="password" placeholder="비밀번호를 입력해주세요."
								class="input input-bordered" maxlength="20">
						</div>

						<div class="flex flex-col mb-4 md:flex-row">
							<div class="p-1 md:flex-grow">
								<input
									class="w-full btn-primary bg-gray-400 hover:bg-gray-200 text-white font-bold py-2 px-4 rounded"
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
		</div>
	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
