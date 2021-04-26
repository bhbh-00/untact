<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../part/head.jspf"%>

<!-- lodash -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>
	
<!-- sha256 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>
	

<script>
const JoinForm__checkAndSubmitDone = false;
<!--  const = var / 중복 방지를 위한.  -->
let JoinForm__validLoginId = '';
//로그인 아이디 중복체크 함수 ajax
function JoinForm__checkLoginIdDup(obj) {
	
	const form = $('.formLogin').get(0);
	
	form.loginId.value = form.loginId.value.trim();
	
	if (form.loginId.value.length == 0) {
		return;
	}
	
	// 편지라고 생각하면 됌!
	$.get(
		'getLoginIdDup',
		// url
		{
			loginId:form.loginId.value
		},
		function(data) {
			
			let colorClass = 'text-green-500';
			
			if ( data.fail ) {	
				colorClass = 'text-red-500';
			}
			
			$('.loginIdInputMsg').html("<span class='" + colorClass + "'>" + data.msg + "</span>");
			
			if ( data.fail ) {
				form.loginId.focus();
			}
			
			else {
				JoinForm__validLoginId = data.body.loginId;
			}
			
		
		},
		
		'json'
		
		/* 형식
		(html -> html)
		(json -> json)
		*/
	);
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
		alert('아이디 중복체크를 해주세요.');
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
	
	/// 파일 업로드
	// ajax를 사용하는 이유는 파일 전송을 폼 전송으로 할 때 화면이 전환 되니깐
	const submitForm = function(data) {
		
		if (data) {
			
			form.genFileIdsStr.value = data.body.genFileIdsStr;
			
		}

		form.submit();
		JoinForm__checkAndSubmitDone = true;
		
	}
	
	function startUpload(onSuccess) {
		
		if (!form.file__member__0__common__attachment__1.value) {
			onSuccess();
			return;
		}

		const formData = new FormData(form);

		$.ajax({
			url : '/common/genFile/doUpload',
			data : formData,
			processData : false,
			contentType : false,
			dataType : "json",
			type : 'POST',
			success : onSuccess
		});

		// 파일을 업로드 한 후
		// 기다린다.
		// 응답을 받는다.
		// onSuccess를 실행한다.
	}
	
	
	form.loginPw.value = sha256(form.loginPwInput.value);
	form.loginPwInput.value = '';
	form.loginPwConfirm.value = '';
	
	startUpload(submitForm);
}

$(function() {
	$('.inputLoginId').change(function() {
		JoinForm__checkLoginIdDup();
	});
	
	$('.inputLoginId').keyup(_.debounce(JoinForm__checkLoginIdDup, 1000));
});
</script>

<section class="section">

	<div class="container mx-auto min-h-screen flex items-center justify-center">
		<div class="w-full">
			<div class="logo-bar flex justify-center mt-3">
				<a href="/usr/member/login" class="logo">
					<span>
						<i class="fas fa-people-arrows"></i>
					</span>
					<span>UNTACT</span>
				</a>
			</div>

			<div class="section-member-join">
				<div class="container mx-auto mt-4">
					<div class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

						<div class="px-4 py-8">

							<form class="formLogin grid form-type-1" action="doJoin" method="POST"
								onsubmit="JoinForm__checkAndSubmit(this); return false;">

								<input type="hidden" name="genFileIdsStr" />
								<input type="hidden" name="redirectUrl" value="${param.redirectUrl}" />
								<input type="hidden" name="loginPw" />

								<!-- loginId -->
								<div class="form-control">
									<label class="label">
										<span class="label-text">아이디</span>
									</label>
									<input type="text" name="loginId" placeholder="영문 혹은 영문+숫자만 입력해주세요." class="inputLoginId input input-bordered">
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
									<input autofocus="autofocus" type="password" placeholder="영문+숫자 조합으로 입력해주세요." name="loginPwInput" maxlength="20" class="input input-bordered">
								</div>

								<!-- 비밀번호 확인 -->
								<div class="form-control">
									<label class="label">
										<span class="label-text">비밀번호 확인</span>
									</label>
									<input autofocus="autofocus" type="password" placeholder="비밀번호와 일치해야합니다." name="loginPwConfirm" maxlength="20" class="input input-bordered">
								</div>


								<!-- 프로필이미지 -->
								<div class="form-control">
									<label class="label">
										<span class="label-text">프로필 이미지</span>
									</label>
									<div>
										<input class="thumb-available" data-thumb-selector="next().next()" type="file" name="file__member__0__common__attachment__1" placeholder="프로필이미지"
											accept="image/png, image/jpeg, image/png">
										<div class="mt-2"></div>
									</div>
								</div>

								<!-- name -->
								<div class="form-control">
									<label class="label">
										<span class="label-text">이름</span>
									</label>
									<input autofocus="autofocus" type="text" placeholder="ex) 홍길동" name="name" maxlength="20" class="input input-bordered">
								</div>

								<!-- nickname -->
								<div class="form-control">
									<label class="label">
										<span class="label-text">닉네임</span>
									</label>
									<input autofocus="autofocus" type="text" placeholder="영문과 한글만 입력해주세요." name="nickname" maxlength="20" class="input input-bordered">
								</div>

								<!-- email -->
								<div class="form-control">
									<label class="label">
										<span class="label-text">email</span>
									</label>
									<input autofocus="autofocus" type="email" placeholder="@untact.com" name="email" maxlength="100" class="input input-bordered">
								</div>

								<!-- cellphoneNo -->
								<div class="form-control">
									<label class="label">
										<span class="label-text">전화번호</span>
									</label>
									<input autofocus="autofocus" type="tel" placeholder="-는 제외해주세요. ex) 01000000000" name="cellphoneNo" maxlength="11" class="input input-bordered">
								</div>
								
								<div class="form-control mt-4">
									<input type="submit" class="btn btn-wide btn-sm mb-1 bg-gray-400 border-transparent w-full text-base" value="회원가입">					
								</div>

							</form>

						</div>
					</div>
				</div>
			</div>

		</div>
	</div>
</section>

<%@ include file="../part/foot.jspf"%>
