<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<section class="section-1">
	<div class="component-title-bar container mx-auto bg-white">
		<span class="text-lg ml-2 py-1">회원리스트</span>
	</div>

	<div class="section-member-list">
		<div class="container mx-auto">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

				<div class="flex py-2">
					<div class="flex-grow"></div>

					<select class="select-auth-level py-1">
						<option value="">권한전체</option>
						<option value="3">일반회원</option>
						<option value="7">관리자</option>
						<!-- selected="selected" : 기본적으로 이 친구로 되어있다. -->
					</select>
					<script>
						if (!param.authLevel) {
							param.authLevel = '';
						}

						$('.section-1 .select-auth-level').val(param.authLevel);

						$('.section-1 .select-auth-level').change(function() {
							location.href = "?authLevel=" + this.value;
						});
						/* change 바뀔 때 마다 뭔가 실행된다.*/
					</script>
				</div>
				
				<c:forEach items="${members}" var="member">
					<div class="px-4 py-8">

						<!-- 반복문 안에 임시변수를 넣어둘 수 있음! c:set -->
						<c:set var="detailUrl" value="detail?id=${member.id}" />

						<div
							class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
							<a href="#" class="row-span-3 order-1">
								<img class="rounded-full" src="https://i.pravatar.cc/100?img=37"
									alt="">
							</a>

							<a href="${detailUrl}" class="order-2">
								<span class="badge badge-primary">번호</span>
								<span>${member.id}</span>
							</a>

							<a href="list?authLevel=${member.authLevel}"
								class="cursor-pointer order-3">
								<span class="badge badge-accent">회원타입</span>
								<span>${member.authLevelName}</span>
							</a>

							<a href="${detailUrl}" class="order-4">
								<span class="badge">등록날짜</span>
								<span class="text-gray-600 text-light">${member.regDate}</span>
							</a>

							<a href="${detailUrl}" class="order-5">
								<span class="badge">수정날짜</span>
								<span class="text-gray-600 text-light">${member.updateDate}</span>
							</a>

							<a href="${detailUrl}" class="order-6">
								<span class="badge">로그인아이디</span>
								<span class="text-gray-600">${member.loginId}</span>
							</a>

							<a href="${detailUrl}" class="order-7">
								<span class="badge">이름</span>
								<span class="text-gray-600">${member.name}</span>
							</a>

							<a href="${detailUrl}" class="order-8 sm:order-4 md:order-8">
								<span class="badge">닉네임</span>
								<span class="text-gray-600">${member.nickname}</span>
							</a>
						</div>

						<div class="grid grid-item-float gap-3 mt-4">
							<a href="${detailUrl}" class="text-blue-500" title="자세히 보기">
								<span>
									<i class="fas fa-info"></i>
									<span>자세히 보기</span>
								</span>
							</a>
							<a href="modify?id=${member.id}" class="text-blue-500 ">
								<span>
									<i class="fas fa-edit"></i>
									<span>수정</span>
								</span>
							</a>
							<a onclick="if ( !confirm('삭제하시겠습니까?') ) return false;"
								href="doDelete?id=${member.id}" class="text-blue-500 ">
								<span>
									<i class="fas fa-trash"></i>
									<span>삭제</span>
								</span>
							</a>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>