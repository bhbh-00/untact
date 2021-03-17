<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>
<%@ page import="com.sbs.untact.util.Util"%>

<script>
	const ModifyMember_checkAndSubmitDone = false;

	function ModifyMember_checkAndSubmit(form) {

		if (ModifyMember_checkAndSubmitDone) {
			return;
		}

		if (form.loginPw.value) {
			form.loginPw.value = form.loginPw.value.trim();
			if (form.loginPw.value.length == 0) {
				alert('비밀번호를 입력해주세요.');
				form.loginPw.focus();

				return;
			}

			form.loginPwConfirm.value = form.loginPwConfirm.value.trim();
			if (form.loginPwConfirm.value.length == 0) {
				alert('비밀번호를 확인해주세요.');
				form.loginPwConfirm.focus();

				return;
			}

			if (form.loginPw.value != form.loginPwConfirm.value) {
				alert('로그인비번이 일치하지 않습니다.');
				form.loginPwConfirm.focus();
				return;
			}
		}

		form.name.value = form.name.value.trim();

		if (form.name.value.length == 0) {
			alert('이름을 입력해주세요.');
			form.name.focus();

			return;
		}

		form.nickname.value = form.nickname.value.trim();

		if (form.nickname.value.length == 0) {
			alert('nickname을 입력해주세요.');
			form.nickname.focus();

			return;
		}

		form.cellphoneNo.value = form.cellphoneNo.value.trim();

		if (form.cellphoneNo.value.length == 0) {
			alert('핸드폰번호를 입력해주세요.');
			form.cellphoneNo.focus();

			return;
		}

		form.email.value = form.email.value.trim();

		if (form.email.value.length == 0) {
			alert('이메일을 입력해주세요.');
			form.email.focus();

			return;
		}

		// 파일 업로드
		// ajax를 사용하는 이유는 파일 전송을 폼 전송으로 할 때 화면이 전환 되니깐
		function startUpload(onSuccess) {
			if (!form["file__member__" + param.id + "__common__attachment__1"].value) {
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

			const submitForm = function(data) {
				if (data) {
					form.genFileIdsStr.value = data.body.genFileIdsStr;
				}

				form.submit();
				ModifyMember_checkAndSubmitDone = true;

		}

		startUpload(submitForm);
	}
</script>

<section class="section-1">
	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<form onsubmit="ModifyMember_checkAndSubmit(this); return false;"
			action="doModify" method="POST">
			<input type="hidden" name="genFileIdsStr" value="" />
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

			<!-- 프로필 -->
			<div class="form-row flex flex-col my-5 lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>프로필</span>
				</div>
				<div class="lg:flex-grow">
					<input accept="image/gif, image/jpeg, image/png"
						class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
						autofocus="autofocus" type="file" placeholder="프로필을 선택해주세요."
						name="file__member__${member.id}__common__attachment__1"
						maxlength="20" />
					<c:set var="fileNo" value="${String.valueOf(1)}" />
					${member.extra.file__common__attachment[fileNo].mediaHtml}
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
					<span>권한레벨</span>
				</div>
				<div class="lg:flex-grow">
					<input
						class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
						autofocus="autofocus" type="text" name="authLevel" maxlength="5"
						value="${member.authLevel}" />
				</div>
			</div>


			<div class="flex flex-col my-3 md:flex-row">
				<div class="p-1 md:flex-grow">
					<input
						class="btn-primary bg-blue-500 text-white font-bold py-2 px-4 rounded"
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
