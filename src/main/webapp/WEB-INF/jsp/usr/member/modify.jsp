<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<!-- lodash -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>

<!-- sha256 -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<script>
	const ModifyMember_checkAndSubmitDone = false;

	function ModifyMember_checkAndSubmit(form) {

		if (ModifyMember_checkAndSubmitDone) {

			return;
		}

		form.loginPwInput.value = form.loginPwInput.value.trim();

		if (form.loginPwInput.value.length == 0) {
			alert('비밀번호를 입력해주세요.');
			form.loginPwInput.focus();

			return;
		}

		if (form.loginPwConfirm.value.length == 0) {
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

		if (form.name.value.length == 0) {
			alert('이름을 입력해주세요.');
			form.name.focus();
			return;
		}

		form.nickname.value = form.nickname.value.trim();

		if (form.nickname.value.length == 0) {
			alert('닉네임을 입력해주세요.');
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
		}
		const submitForm = function(data) {
			if (data) {
				form.genFileIdsStr.value = data.body.genFileIdsStr;
			}

			form.submit();
			ModifyMember_checkAndSubmitDone = true;

		}

		form.loginPw.value = sha256(form.loginPwInput.value);
		form.loginPwInput.value = '';
		form.loginPwConfirm.value = '';

		startUpload(submitForm);
	}
</script>

<section class="section-usr-member-modify">

	<div class="section-member-modify mb-10">
		<div class="container mx-auto">
			<div class="card bordered shadow-lg bg-white">

				<div class="card-title border-gray-400 border-b">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>내 정보수정</span>
				</div>

				<div class="px-4 py-8">

					<form class="grid form-type-1"
						onsubmit="ModifyMember_checkAndSubmit(this); return false;"
						action="doModify" method="POST">

						<input type="hidden" name="genFileIdsStr" />
						<input type="hidden" name="id" value="${member.id}" />
						<input type="hidden" name="loginPw" />
						<input type="hidden" name="authLevel" value="${member.authLevel}" />
						<input type="hidden" name="checkPasswordAuthCode"
							value="${param.checkPasswordAuthCode}">

						<!-- 번호 -->
						<div class="form-control">
							<label class="cursor-pointer label"> 번호 </label>
							<div class="plain-text">${member.id}</div>
						</div>

						<!-- 등록날짜 -->
						<div class="form-control">
							<label class="cursor-pointer label"> 등록날짜 </label>
							<div class="plain-text">${member.regDate}</div>
						</div>

						<!-- 수정날짜 -->
						<c:if test="${member.regDate != member.updateDate}">
							<div class="form-control">
								<label class="cursor-pointer label"> 수정날짜 </label>
								<div class="plain-text">${member.updateDate}</div>
							</div>
						</c:if>

						<!-- 아이디 -->
						<div class="form-control">
							<label class="cursor-pointer label"> 아이디 </label>
							<div class="plain-text">${member.loginId}</div>
						</div>

						<!-- 프로필 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">프로필</span>
							</label>
							<div>
								<input accept="image/gif, image/jpeg, image/png"
									class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
									autofocus="autofocus" type="file" placeholder="프로필이미지를 선택해주세요."
									name="file__member__${member.id}__common__attachment__1"
									maxlength="20" />
								<div class="mt-3">
									<c:set var="fileNo" value="${String.valueOf(1)}" />
									${member.extra.file__common__attachment[fileNo].mediaHtml}
								</div>
							</div>
						</div>

						<!-- 비밀번호 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">비밀번호</span>
							</label>
							<input type="password" name="loginPwInput" placeholder="비밀번호"
								maxlength="30" class="input input-bordered">
						</div>

						<!-- 비밀번호 확인 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">비밀번호 확인</span>
							</label>
							<input type="password" name="loginPwConfirm"
								placeholder="비밀번호 확인" class="input input-bordered"
								maxlength="30">
						</div>

						<!-- 이름 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">이름</span>
							</label>
							<input type="text" placeholder="이름 입력해주세요." name="name"
								class="input input-bordered" value="${member.name}">
						</div>

						<!-- 닉네임 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">닉네임</span>
							</label>
							<input type="text" name="nickname" class="input input-bordered"
								value="${member.nickname}">
						</div>

						<!-- 이메일 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">이메일</span>
							</label>
							<input type="email" name="email" class="input input-bordered"
								value="${member.email}">
						</div>

						<!-- 전화번호 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">전화번호</span>
							</label>
							<input type="text" name="cellphoneNo"
								class="input input-bordered" value="${member.cellphoneNo}">
						</div>

						<div class="mt-2">
							<button class="btn btn-ghost btn-sm mb-1 text-blue-500"
								type="submit">
								<i class="fas fa-edit mr-1"></i>
								<span>수정</span>
							</button>
							<a onclick="history.back();"
								class="btn btn-ghost btn-sm mb-1 text-red-500">
								<i class="fas fa-trash mr-1"></i>
								<span>취소</span>
							</a>
						</div>

					</form>

				</div>
			</div>
		</div>
	</div>
</section>


<%@ include file="../part/mainLayoutFoot.jspf"%>
