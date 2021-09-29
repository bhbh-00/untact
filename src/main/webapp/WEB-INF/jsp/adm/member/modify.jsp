<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<!-- sha256 -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<section class="section-adm-member-modify">

	<div class="section-member-modify">
		<div class="container mx-auto">
			<div class="card bordered shadow-lg bg-white">

				<div class="card-title border-gray-400 border-b">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>회원정보 수정</span>
				</div>

				<div class="px-4 py-8">

					<form class="grid form-type-1"
						onsubmit="ModifyMember_checkAndSubmit(this); return false;"
						action="doModify" method="POST">

						<input type="hidden" name="id" value="${member.id}" />
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

						<!-- 회원타입 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">회원타입</span>
							</label>
							<select name="authLevel" class="select select-auth-level">
								<option disabled="disabled" selected="selected">회원타입을
									선택해주세요.</option>
								<option value="3">일반</option>
								<option value="7">관리자</option>
							</select>
							<script>
								const memberAuthLevel = parseInt("${member.authLevel}");
							</script>
							<script>
								$('.section-adm-member-modify .select-auth-level').val(memberAuthLevel);
							</script>
						</div>

						<!-- 이름 -->
						<div class="form-control">
							<label class="cursor-pointer label"> 이름 </label>
							<div class="plain-text">${member.name}</div>
						</div>


						<!-- 닉네임 -->
						<div class="form-control">
							<label class="cursor-pointer label"> 닉네임 </label>
							<div class="plain-text">${member.nickname}</div>
						</div>

						<!-- 이메일 -->
						<div class="form-control">
							<label class="cursor-pointer label"> 이메일 </label>
							<div class="plain-text">${member.email}</div>
						</div>

						<!-- 전화번호 -->
						<div class="form-control">
							<label class="cursor-pointer label"> 전화번호 </label>
							<div class="plain-text">${member.cellphoneNo}</div>
						</div>

						<div class="form-control mt-4">
							<div class="p-1 md:flex-grow">
								<input
									class="w-full btn-primary bg-gray-400 hover:bg-gray-200 text-white font-bold py-2 px-4 rounded"
									type="submit" value="수정" />
							</div>
						</div>

					</form>

				</div>
			</div>
		</div>
	</div>
</section>


<%@ include file="../part/mainLayoutFoot.jspf"%>
