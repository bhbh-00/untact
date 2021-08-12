<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/head.jspf"%>

<!-- lodash -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>

<!-- sha256 -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<script>
	const JoinForm__checkAndSubmitDone = false;

	let JoinForm__validLoginId = '';

	// 로그인 아이디 중복체크 함수
	function JoinForm__checkLoginIdDup() {
		const form = $('.formLogin').get(0);

		form.loginId.value = form.loginId.value.trim();

		if (form.loginId.value.length == 0) {
			return;
		}

		$.get('getLoginIdDup', {
			loginId : form.loginId.value
		}, function(data) {
			let colorClass = 'text-green-500';

			if (data.fail) {
				colorClass = 'text-red-500';
			}

			$('.loginIdInputMsg').html("<span class='" + colorClass + "'>" + data.msg + "</span>");

			if (data.fail) {
				form.loginId.focus();
			} else {
				JoinForm__validLoginId = data.body.loginId;
			}

		}, 'json');
	}
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
		
		if ( form.loginId.value != JoinForm__validLoginId ) {
			alert('입력하신 아이디를 확인해 주세요.');
			form.loginId.focus();
			
			return;
		}
			
		form.loginPwInput.value = form.loginPwInput.value.trim();
		
		if ( form.loginPwInput.value.length == 0 ) {
			alert('비밀번호를 입력해주세요.');
			form.loginPwInput.focus();
			
			return;
		}
			
		if ( form.loginPwConfirm.value.length == 0 ) {
			alert('비밀번호를 확인해주세요.');
			form.loginPwConfirm.focus();
			
			return;
		}
		
		if (form.loginPwInput.value != form.loginPwConfirm.value) {
			alert('비밀번호가 일치하지 않습니다.');
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

		form.nickname.value = form.nickname.value.trim();

		if (form.nickname.value.length == 0) {
			alert('별명을 입력해주세요.');
			form.nickname.focus();

			return;
		}

		form.email.value = form.email.value.trim();

		if (form.email.value.length == 0) {
			alert('이메일을 입력해주세요.');
			form.email.focus();

			return;
		}

		form.cellphoneNo.value = form.cellphoneNo.value.trim();

		if (form.cellphoneNo.value.length == 0) {
			alert('휴대전화번호를 입력해주세요.');
			form.cellphoneNo.focus();

			return;
		}

		form.loginPw.value = sha256(form.loginPwInput.value);
		form.loginPwInput.value = '';
		form.loginPwConfirm.value = '';
		
		form.submit();
		JoinForm__checkAndSubmitDone = true;
	}
	
	$(function() {
		$('.inputLoginId').change(function() {
			JoinForm__checkLoginIdDup();
		});

		$('.inputLoginId').keyup(_.debounce(JoinForm__checkLoginIdDup, 1000));
	});
</script>
<section class="section-member-join">

	<div
		class="container mx-auto min-h-screen flex items-center justify-center">

		<div class="w-full">

			<div class="logo-bar flex justify-center mb-5">
				<a href="../home/main" class="logo">
					<span>
						<i class="fas fa-people-arrows"></i>
					</span>
					<span>UNTACT</span>
				</a>
			</div>

			<div
				class="container mx-auto bg-white card bordered shadow-lg px-5 pt-5 pb-3">

				<div class="container mx-auto flex text-xl mt-4 ml-5">
					<span class="flex items-center mr-1">
						<i class="fas fa-user-edit"></i>
					</span>
					<span class="font-bold"> 회원가입 </span>
				</div>

				<div class="px-4 py-8">

					<form class="formLogin grid form-type-1" action="doJoin"
						method="POST"
						onsubmit="JoinForm__checkAndSubmit(this); return false;">

						<input type="hidden" name="redirectUrl"
							value="${param.redirectUrl}" />
						<input type="hidden" name="loginPw" />
						<input type="hidden" name="authLevel" value="3"/>

						<!-- loginId -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">아이디</span>
							</label>
							<input type="text" name="loginId"
								placeholder="영문 혹은 영문+숫자만 입력해주세요."
								class="inputLoginId input input-bordered">
						</div>

						<!-- 아이디 중복여부를 ajax로 물어봄 -->
						<div class="form-control">
							<div class="loginIdInputMsg"></div>
						</div>

						<!-- 비밀번호 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">비밀번호</span>
							</label>
							<input autofocus="autofocus" type="password"
								placeholder="영문+숫자 조합으로 입력해주세요." name="loginPwInput"
								maxlength="30" class="input input-bordered">
						</div>

						<!-- 비밀번호 확인 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">비밀번호 확인</span>
							</label>
							<input autofocus="autofocus" type="password"
								placeholder="비밀번호와 일치해야합니다." name="loginPwConfirm"
								maxlength="20" class="input input-bordered">
						</div>

						<!-- name -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">이름</span>
							</label>
							<input autofocus="autofocus" type="text" placeholder="ex) 홍길동"
								name="name" maxlength="20" class="input input-bordered">
						</div>

						<!-- nickname -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">닉네임</span>
							</label>
							<input autofocus="autofocus" type="text"
								placeholder="영문과 한글만 입력해주세요." name="nickname" maxlength="20"
								class="input input-bordered">
						</div>

						<!-- email -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">email</span>
							</label>
							<input autofocus="autofocus" type="email"
								placeholder="@untact.com" name="email" maxlength="100"
								class="input input-bordered">
						</div>

						<!-- cellphoneNo -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">전화번호</span>
							</label>
							<input autofocus="autofocus" type="tel"
								placeholder="-는 제외해주세요. ex) 01000000000" name="cellphoneNo"
								maxlength="11" class="input input-bordered">
						</div>

						<div class="form-control mt-4">
							<input type="submit"
								class="btn btn-wide btn-sm mb-1 bg-gray-400 border-transparent w-full text-base"
								value="회원가입">
						</div>

					</form>

				</div>
			</div>
		</div>
	</div>

</section>

<%@ include file="../part/foot.jspf"%>

