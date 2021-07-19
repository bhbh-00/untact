<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<section class="section-1">

	<div class="section-member-detail">
		<div class="container mx-auto">
			<div class="card bordered shadow-lg bg-white">
			
				<div class="card-title bg-gray-400 text-white">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>회원 프로필</span>
				</div>

				<div class="px-4 py-3">

					<c:set var="detailUrl" value="detail?id=${member.id}" />

					<!-- 프로필 이미지 -->
					<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
						<a href="#" class="row-span-3 order-1">
							<img class="w-40 h-40 object-cover rounded-full" onerror="${member.profileFallbackImgOnErrorHtmlAttr}" src="${member.profileImgUrl}"
								alt="">
						</a>
						
						<!-- 번호 -->
						<a href="${detailUrl}" class="order-2">
							<span class="badge badge-warning">번호</span>
							<span>${member.id}</span>
						</a>
						
						<!-- 회원타입 -->
						<a href="list?authLevel=${member.authLevel}"
							class="cursor-pointer order-3">
							<span class="badge badge-info">회원타입</span>
							<span>${member.authLevelName}</span>
						</a>
						
						<!-- 등록날짜 -->
						<a href="${detailUrl}" class="order-4">
							<span class="badge">등록날짜</span>
							<span class="text-gray-600 text-light">${member.regDate}</span>
						</a>
						
						<!-- 수정날짜 -->
						<a href="${detailUrl}" class="order-5">
							<span class="badge">수정날짜</span>
							<span class="text-gray-600 text-light">${member.updateDate}</span>
						</a>
						
						<!-- 로그인아이디 -->
						<a href="${detailUrl}" class="order-6">
							<span class="badge">아이디</span>
							<span class="text-gray-600">${member.loginId}</span>
						</a>
						
						<!-- 이름 -->
						<a href="${detailUrl}" class="order-7">
							<span class="badge">이름</span>
							<span class="text-gray-600">${member.name}</span>
						</a>
						
						<!-- 닉네임 -->
						<a href="${detailUrl}" class="order-8 sm:order-4 md:order-8">
							<span class="badge">닉네임</span>
							<span class="text-gray-600">${member.nickname}</span>
						</a>
					</div>

					<div class="grid grid-item-float gap-3 mt-4">
						
						<a href="modify?id=${member.id}" class="text-blue-500 ">
							<span>
								<i class="fas fa-edit"></i>
								<span>수정</span>
							</span>
						</a>
						<a onclick="if ( !confirm('회원 탈퇴하시겠습니까?') ) return false;"
							href="doDelete?id=${member.id}" class="text-blue-500 ">
							<span>
								<i class="fas fa-trash"></i>
								<span>삭제</span>
							</span>
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>