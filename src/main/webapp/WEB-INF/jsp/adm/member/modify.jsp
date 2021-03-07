<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>
<%@ page import="com.sbs.untact.util.Util"%>

<script>
const MemberModify__checkAndSubmitDone = false;
<!--  const = var / 중복 방지를 위한.  -->
function MemberModify__checkAndSubmit(form) {
	if ( MemberModify__checkAndSubmitDone ) {
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
	MemberModify__checkAndSubmitDone = true;
}
</script>

<section class="section-1">
	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<form onsubmit="MemberModify__checkAndSubmit(this); return false;"
			action="doModify" method="GET">
			<input type="hidden" name="id" value="${member.id}" />
			<span class="text-3xl text-black font-bold">회원 정보 수정</span>
			<!-- loginId -->
			<div class="form-row flex flex-col mt-7 mb-5 lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>아이디</span>
				</div>
				<div class="lg:flex-grow">${member.loginId}</div>
			</div>

			<!-- loginPw -->
			<div class="form-row flex flex-col my-5 lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>비밀번호</span>
				</div>
				<div class="lg:flex-grow">
					<input
						class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
						autofocus="autofocus" type="password" placeholder="비밀번호를 입력해주세요."
						name="loginPw" maxlength="20" />
				</div>
			</div>

			<!-- loginPw 확인 -->
			<div class="form-row flex flex-col my-5 lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>비밀번호 확인</span>
				</div>
				<div class="lg:flex-grow">
					<input
						class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
						autofocus="autofocus" type="password" placeholder="비밀번호와 일치해야합니다."
						name="loginPwConfirm" maxlength="20" />
				</div>
			</div>

			<!-- name -->
			<div class="form-row flex flex-col my-5 lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>이름</span>
				</div>
				<div class="lg:flex-grow">
					<input
						class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
						autofocus="autofocus" type="text" placeholder="ex) 홍길동"
						name="name" maxlength="20" value="${member.name}" />
				</div>
			</div>

			<!-- nickname -->
			<div class="form-row flex flex-col my-5 lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>닉네임</span>
				</div>
				<div class="lg:flex-grow">
					<input
						class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
						autofocus="autofocus" type="text" placeholder="영문과 한글만 입력해주세요."
						name="nickname" maxlength="20" value="${member.nickname}" />
				</div>
			</div>

			<!-- email -->
			<div class="form-row flex flex-col my-5 lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>이메일</span>
				</div>
				<div class="lg:flex-grow">
					<input
						class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
						autofocus="autofocus" type="text" placeholder="@untact.com"
						name="email" maxlength="100" value="${member.email}" />
				</div>
			</div>

			<!-- cellphoneNo -->
			<div class="form-row flex flex-col mt-5 mb-7 lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>전화번호</span>
				</div>
				<div class="lg:flex-grow">
					<input
						class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
						autofocus="autofocus" type="tel"
						placeholder="-는 제외해주세요. ex) 01000000000" name="cellphoneNo"
						maxlength="11" value="${member.cellphoneNo}" />
				</div>
			</div>

			<!-- 권한 레벨 -->
			<div class="form-row flex flex-col mt-5 mb-7 lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>권한 레벨</span>
				</div>
				<div class="lg:flex-grow">
					<select class="select-auth-level w-full  py-2 px-3">
						<option value="3">일반회원</option>
						<option value="7">관리자</option>
						<!-- selected="selected" : 기본적으로 이 친구로 되어있다. -->						
					</select>
					<script>
					$('.section-1 .select-auth-level').val(member.authLevel);
					$('.section-1 .select-auth-level').change(function() {
						location.href = "?member.authLevel=" + this.value;
					});
					/* change 바뀔 때 마다 뭔가 실행된다.*/
				</script>
				</div>
			</div>

			<div class="flex flex-col my-3 md:flex-row">
				<div class="p-1 md:flex-grow">
					<input
						class="btn-primary bg-blue-400 text-white font-bold py-2 px-4 rounded"
						type="submit" value="수정" />
					<input onclick="history.back();" type="button"
						class="btn-info bg-red-600 text-white font-bold py-2 px-4 rounded"
						value="취소">
				</div>
			</div>

		</form>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
