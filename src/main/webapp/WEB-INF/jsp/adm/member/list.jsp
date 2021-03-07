<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<section class="section-1">
<c:forEach items="${members}" var="member">
	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<span class="text-3xl text-black font-bold">멤버 관리</span>
		<hr>

		<!-- 번호 -->
		<div class="flex flex-col mt-4 ml-4 md:flex-row">
			<div class="md:w-36 md:flex md:items-center">
				<span>${member.id}</span>
			</div>
		</div>

		<!-- 아이디 -->
		<div class="flex flex-col ml-4 md:flex-row">
			<div class="md:w-36 md:flex md:items-center">
				<span>${member.loginId}</span>
			</div>
		</div>

		<!-- 등록날짜 -->
		<div class="flex flex-col ml-4 md:flex-row">
			<div class="md:w-36 md:flex md:items-center">
				<span>${member.regDate}</span>
			</div>
		</div>

		<!-- 이름 -->
		<div class="flex flex-col ml-4 md:flex-row">
			<div class="md:w-36 md:flex md:items-center">
				<span>${member.name}</span>
			</div>
		</div>

		<!-- 닉네임 -->
		<div class="flex flex-col ml-4 md:flex-row">
			<div class="md:w-36 md:flex md:items-center">
				<span>${member.name}</span>
			</div>
		</div>

		<!-- nickname -->
		<div class="flex flex-col ml-4 md:flex-row">
			<div class="md:w-36 md:flex md:items-center">
				<span>${member.nickname}</span>
			</div>
		</div>

		<div class="flex flex-col mb-4 md:flex-row">
			<div class="p-1 md:flex-grow">
				<select class="select-board-id py-1">
					<option value="3">일반</option>
					<option value="7">관리자</option>
					<!-- selected="selected" : 기본적으로 이 친구로 되어있다. -->
				</select>
				<script>
					$('.section-1 .select-board-id').val(member.authLevel);

					$('.section-1 .select-board-id').change(function() {
						location.href = "?member.authLevel=" + this.value;
					});
					/* change 바뀔 때 마다 뭔가 실행된다.*/
				</script>
				<a
					class="btn-primary bg-blue-500 hover:bg-blue-dark text-white font-bold py-1 px-2 rounded mb-5"
					href="doModify?authLevel=${member.authLevel}">수정</a>
			</div>
			<input onclick="history.back();" type="button"
				class="btn-info bg-red-500 text-white font-bold py-2 px-4 rounded"
				value="취소">
		</div>
	</div>
	</c:forEach>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>