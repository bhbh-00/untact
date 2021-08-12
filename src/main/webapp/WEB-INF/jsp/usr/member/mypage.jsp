
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.sbs.untact.util.Util"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<section class="section-member-mypage">

	<div class="container mx-auto">
		<div class="card bordered shadow-lg item-bt-1-not-last-child bg-white">
			<div class="card-title bg-white">
				<a href="javascript:history.back();" class="cursor-pointer">
					<i class="fas fa-chevron-left"></i>
				</a>
				<span>내 프로필</span>
			</div>

			<div class="p-4">

				<!-- 회원타입 -->
				<a href="list?authLevel=${loginedMember.authLevel}"
					class="cursor-pointer hover:underline">
					<span class="badge ${loginedMember.authLevelNameColor}">${loginedMember.authLevelName}</span>
				</a>

				<!-- 번호 -->
				<a href="#" class="hover:underline">
					<span class="text-base">No.${member.id}</span>
				</a>

				<div
					class="mt-3 grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-2">

					<!-- 아이디 -->
					<a href="#" class="cursor-pointer hover:underline">
						<span class="badge badge-outline mb-1">아이디</span>
						<span>${member.loginId}</span>
					</a>

					<!-- 이름 -->
					<a href="#" class="cursor-pointer hover:underline">
						<span class="badge badge-outline mb-1">이름</span>
						<span>${loginedMember.name}</span>
					</a>

					<!-- 닉네임 -->
					<a href="#" class="cursor-pointer hover:underline">
						<span class="badge badge-outline mb-1">닉네임</span>
						<span>${loginedMember.nickname}</span>
					</a>

					<!-- 핸드폰번호 -->
					<a href="#" class="cursor-pointer hover:underline">
						<span class="badge badge-outline mb-1">핸드폰번호</span>
						<span>${loginedMember.cellphoneNo}</span>
					</a>

					<!-- 이메일 -->
					<a href="#" class="cursor-pointer hover:underline">
						<span class="badge badge-outline mb-1">닉네임</span>
						<span>${loginedMember.email}</span>
					</a>

					<!--  -->
					<a href="#">
						<span></span>
						<span></span>
					</a>

					<!-- 등록날짜 -->
					<a href="#" class="hover:underline">
						<span class="badge">등록날짜</span>
						<span class="text-gray-600 text-light">${loginedMember.regDate}</span>
					</a>

					<!-- 수정날짜 -->
					<c:if test="${loginedMember.updateDate != loginedMember.regDate}">
						<a href="#" class="hover:underline">
							<span class="badge">수정날짜</span>
							<span class="text-gray-600 text-light">${loginedMember.updateDate}</span>
						</a>
					</c:if>

				</div>

				<div class="grid grid-item-float gap-3 mt-4">

					<a
						href="checkPassword?afterUrl=${Util.getUrlEncoded('../member/modify')}"
						class="text-blue-500 ">
						<span>
							<i class="fas fa-edit"></i>
							<span>수정</span>
						</span>
					</a>
					<a onclick="if ( !confirm('회원 탈퇴하시겠습니까?') ) return false;"
						href="doDelete?id=${loginedMember.id}" class="text-red-500 ">
						<span>
							<i class="fas fa-trash"></i>
							<span>회원탈퇴</span>
						</span>
					</a>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>