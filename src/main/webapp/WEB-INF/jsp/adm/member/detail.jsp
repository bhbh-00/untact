<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<section class="section-1">
	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<div class="flex items-center mb-5">
			<span class="text-3xl text-black font-bold">회원 프로필</span>

			<div class="flex-grow"></div>

			<a href="join" class="text-gray-600 inline-block hover:underline">회원가입</a>
		</div>
		<hr>
		<div>
			<!-- 반복문 안에 임시변수를 넣어둘 수 있음! c:set -->
			<c:set var="detailUrl" value="detail?id=${member.id}" />

			<div class="flex justify-between items-center mt-3">

				<!-- 회원 번호 -->
				<a href="${detailUrl}" class="font-bold mr-5">
					<span
						class="inline-flex justify-center items-center px-3 py-1 rounded-full bg-${member.authLevelNameColor}-500 text-white">NO.
						${member.id}</span>
					<span></span>
				</a>

				<!-- 등록날짜 -->
				<span class="font-light text-gray-600">${member.regDate}</span>

				<div class="flex-grow"></div>

				<!-- authLevel 일반/관리자-->
				<a href="list?authLevel=${member.authLevel}"
					class="cursor-pointer px-2 py-1 bg-${member.authLevelNameColor}-500 text-white font-bold rounded">${member.authLevelName}</a>
			</div>

			<!-- 회원 아아디 -->
			<div class="mt-2">
				<span
					class="inline-flex justify-center items-center px-3 py-1 rounded-full bg-${member.authLevelNameColor}-500 text-white">아이디</span>
				<span>${member.loginId}</span>
			</div>

			<!-- 회원 이름 -->
			<div class="mt-2">
				<span
					class="inline-flex justify-center items-center px-3 py-1 rounded-full bg-${member.authLevelNameColor}-500 text-white">이름</span>
				<span>${member.name}</span>
			</div>

			<!-- 회원 닉네임 -->
			<div class="mt-2">
				<span
					class="inline-flex justify-center items-center px-3 py-1 rounded-full bg-${member.authLevelNameColor}-500 text-white">닉네임</span>
				<span>${member.nickname}</span>
			</div>

			<div class="flex items-center mt-4 mb-4">
				<!-- 자세히 보기 
				
				<a href="${detailUrl}" class="text-gray-700 mr-2 hover:underline">
					<span>
						<i class="fas fa-info"></i>
						<span class="hidden sm:inline">자세히 보기</span>
					</span>
				</a>
				
				
				-->
				
				<!-- 수정 -->
				<a href="modify?id=${member.id}"
					class="text-blue-500 mr-2 hover:underline">
					<span>
						<i class="fas fa-edit"></i>
						<span class="hidden sm:inline">수정</span>
					</span>
				</a>

				<!-- 삭제 -->
				<a onclick="if ( !confirm('삭제하시겠습니까?') ) return false;"
					href="doDelete?id=${member.id}"
					class="text-red-500 hover:underline">
					<span>
						<i class="fas fa-trash"></i>
						<span class="hidden sm:inline">삭제</span>
					</span>
				</a>

				<div class="flex-grow"></div>

				<!-- 작성자 -->
				<div>
					<a class="flex items-center">
						<img
							src="https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?ixlib=rb-1.2.1&amp;ixid=eyJhcHBfaWQiOjEyMDd9&amp;auto=format&amp;fit=crop&amp;w=731&amp;q=80"
							alt="avatar" class="mx-4 w-10 h-10 object-cover rounded-full">
						<span class="text-gray-700 font-bold hover:underline">${member.nickname}</span>
					</a>
				</div>
			</div>
			<hr>
		</div>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>