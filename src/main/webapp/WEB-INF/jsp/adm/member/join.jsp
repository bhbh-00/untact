<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../part/head.jspf"%>

<!-- lodash -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>

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
		alert('로그인아이디 중복체크를해주세요.');
		form.loginId.focus();
		
		return;
	}
		
	form.loginPw.value = form.loginPw.value.trim();
	
	if ( form.loginPw.value.length == 0 ) {
		alert('비밀번호를 입력해주세요.');
		form.loginPw.focus();
		
		return;
	}
		
	if ( form.loginPwConfirm.value.length == 0 ) {
		alert('비밀번호를 확인해주세요.');
		form.loginPwConfirm.focus();
		
		return;
	}
	
	if (form.loginPw.value != form.loginPwConfirm.value) {
		alert('로그인비번이 일치하지 않습니다.');
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
			// data가 있다면 
			form.genFileIdsStr.value = data.body.genFileIdsStr;
		}
		
		form.submit();
		JoinForm__checkAndSubmitDone = true;
	}
	
	function startUpload(onSuccess) {
		// 성공 했을 때 실행 되어야할 함수
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
	
	startUpload(submitForm);
}

$(function() {
	$('.inputLoginId').change(function() {
		JoinForm__checkLoginIdDup();
		// change() -> 해당하는 요소의 value에 변화가 생길 경우 이를 감지하여 등록된 callback함수를 동작시킴.
	});
	
	$('.inputLoginId').keyup(_.debounce(JoinForm__checkLoginIdDup, 1000));
	// keyup() -> 키 입력 후 발생되는 이벤트
	
	/* debounce() -> 이벤트를 그룹화하여 특정시간이 지난 후 하나의 이벤트만 발생하도록 하는 기술입니다.
				   순차적 호출을 하나의 그룹으로 "그룹화"할 수 있습니다.
				   연이어 호출되는 함수들 중 마지막 함수(또는 제일 처음)만 호출하도록 하는 것

	*/
});
</script>

<section class="section-Join">
	<div
		class="container mx-auto min-h-screen flex items-center justify-center">
		<div class="w-full">
			<div class="logo-bar flex justify-center mt-3">
				<a href="#" class="logo">
					<span>
						<i class="fas fa-people-arrows"></i>
					</span>
					<span>UNTACT ADMIN</span>
				</a>
			</div>

			<form
				class="formLogin bg-white w-full shadow-md rounded px-8 pt-6 pb-8"
				action="doJoin" method="POST"
				onsubmit="JoinForm__checkAndSubmit(this); return false;">

				<!-- 첨부파일 -->
				<input type="hidden" name="genFileIdsStr" value="" />
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
							class="inputLoginId shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
							autofocus="autofocus" type="text"
							placeholder="영문 혹은 영문+숫자만 입력해주세요." name="loginId" maxlength="20" />
					</div>
				</div>

				<!-- 아이디 중복여부를 ajax로 물어봄 -->
				<div class="loginIdInputMsg ml-2 mb-2"></div>

				<!-- loginPw -->
				<div class="flex flex-col ml-4 md:flex-row">
					<div class="md:w-36 md:flex md:items-center">
						<span>비밀번호</span>
					</div>
				</div>
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
							autofocus="autofocus" type="password"
							placeholder="영문+숫자 조합으로 입력해주세요." name="loginPw" maxlength="20" />
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
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
							autofocus="autofocus" type="password"
							placeholder="비밀번호와 일치해야합니다." name="loginPwConfirm" maxlength="20" />
					</div>
				</div>

				<!-- 프로필 -->
				<div class="flex flex-col ml-4 md:flex-row">
					<div class="md:w-36 md:flex md:items-center">
						<span>프로필</span>
					</div>
				</div>
				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input accept="image/gif, image/jpeg, image/png"
							class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
							autofocus="autofocus" type="file" placeholder="프로필을 선택해주세요."
							name="file__member__0__common__attachment__1" maxlength="20" />
						<!-- accept 내가 원하는 특정 확장자만 받겠다는 의미 -->
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
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
							autofocus="autofocus" type="text" placeholder="ex) 홍길동"
							name="name" maxlength="20" />
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
							autofocus="autofocus" type="text" placeholder="영문과 한글만 입력해주세요."
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
							autofocus="autofocus" type="email" placeholder="@untact.com"
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
							autofocus="autofocus" type="tel"
							placeholder="-는 제외해주세요. ex) 01000000000" name="cellphoneNo"
							maxlength="11" />
					</div>
				</div>

				<div class="flex flex-col mb-4 md:flex-row">
					<div class="p-1 md:flex-grow">
						<input
							class="btn-primary bg-gray-400 text-white font-bold py-2 px-4 rounded"
							type="submit" value="회원가입" />
						<a onclick="history.back();"
							class="btn-info bg-gray-600 hover:bg-blue-dark text-white font-bold py-2 px-4 rounded inline-block">취소</a>
					</div>
				</div>

			</form>

		</div>
	</div>
</section>

<%@ include file="../part/foot.jspf"%>
