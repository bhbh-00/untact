<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.sbs.untact.util.Util"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<script>
	param.boardId = parseInt("${board.id}");
</script>

<section class="section-adm-home-main">

	<div class="mb-14">
		<img class="container mx-auto card shadow-lg"
			src="https://images.unsplash.com/photo-1593642702821-c8da6771f0c6?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1489&q=80">
	</div>

	<div
		class="container mx-auto bg-white card bordered shadow-lg p-5 mb-3">

		<div class="items-center ml-2">
			<span class="text-xl font-bold">
				<span>최근 게시물</span>
			</span>
		</div>
	</div>

	<div class="container mx-auto grid gap-4 grid-cols-2 mb-5">

		<c:forEach items="${LatestArticleByBoardNameFree}" var="articles">

			<!-- 반복문 안에 임시변수를 넣어둘 수 있음! c:set -->
			<c:set var="detailUrl" value="../article/detail?id=${articles.id}" />

			<div class="card bg-white p-6">

				<!-- 게시판 번호 -->
				<!-- 게시물 번호 -->
				<c:if test="${articles.extra__boardName eq '공지사항'}">
					<a href="${detailUrl}" class="cursor-pointer hover:underline">
						<span class="badge badge-info">${articles.extra__boardName}</span>
						<span class="text-base">No.${articles.id}</span>
					</a>
				</c:if>

				<c:if test="${articles.extra__boardName eq '자유'}">
					<a href="${detailUrl}" class="cursor-pointer hover:underline">
						<span class="badge badge-warning">${articles.extra__boardName}</span>
						<span class="text-base">No.${articles.id}</span>
					</a>
				</c:if>

				<div class="mt-3 grid sm:grid-cols-2 xl:grid-cols-2 gap-4">

					<!-- 제목 -->
					<a href="${detailUrl}" class="hover:underline cursor-pointer">
						<span class="badge badge-outline mb-1">제목</span>
						<span class="line-clamp-3 ml-1"> ${articles.title} </span>
					</a>

					<!-- 본문 -->
					<a href="${detailUrl}"
						class="mt-3 hover:underline cursor-pointer col-span-1 sm:col-span-2 xl:col-span-3">
						<span class="badge badge-outline mb-1">본문</span>
						<span class="line-clamp-3 ml-1"> ${articles.body} </span>
					</a>

					<!-- 작성자 -->
					<a href="${detailUrl}" class="cursor-pointer hover:underline">
						<span class="badge badge-accent">작성자</span>
						<span>${articles.extra__writer}</span>
					</a>

					<!-- 등록날짜 -->
					<a href="${detailUrl}" class="hover:underline">
						<span class="badge">등록날짜</span>
						<span class="text-gray-600 text-light">${articles.regDate}</span>
					</a>

					<!-- 수정날짜 -->
					<c:if test="${articles.updateDate != articles.regDate}">
						<a href="${detailUrl}" class="hover:underline">
							<span class="badge">수정날짜</span>
							<span class="text-gray-600 text-light">${articles.updateDate}</span>
						</a>
					</c:if>

				</div>
			</div>
		</c:forEach>

		<c:forEach items="${LatestArticleByBoardNameNotice}" var="articles">

			<!-- 반복문 안에 임시변수를 넣어둘 수 있음! c:set -->
			<c:set var="detailUrl" value="../article/detail?id=${articles.id}" />

			<div class="card bg-white p-6">

				<!-- 게시판 번호 -->
				<!-- 게시물 번호 -->
				<c:if test="${articles.extra__boardName eq '공지사항'}">
					<a href="${detailUrl}" class="cursor-pointer hover:underline">
						<span class="badge badge-info">${articles.extra__boardName}</span>
						<span class="text-base">No.${articles.id}</span>
					</a>
				</c:if>

				<c:if test="${articles.extra__boardName eq '자유'}">
					<a href="${detailUrl}" class="cursor-pointer hover:underline">
						<span class="badge badge-warning">${articles.extra__boardName}</span>
						<span class="text-base">No.${articles.id}</span>
					</a>
				</c:if>


				<div class="mt-3 grid sm:grid-cols-2 xl:grid-cols-2 gap-4">

					<!-- 제목 -->
					<a href="${detailUrl}" class="hover:underline cursor-pointer">
						<span class="badge badge-outline mb-1">제목</span>
						<span class="line-clamp-3 ml-1"> ${articles.title} </span>
					</a>

					<!-- 본문 -->
					<a href="${detailUrl}"
						class="mt-3 hover:underline cursor-pointer col-span-1 sm:col-span-2 xl:col-span-3">
						<span class="badge badge-outline mb-1">본문</span>
						<span class="line-clamp-3 ml-1"> ${articles.body} </span>
					</a>

					<!-- 작성자 -->
					<a href="${detailUrl}" class="cursor-pointer hover:underline">
						<span class="badge badge-accent">작성자</span>
						<span>${articles.extra__writer}</span>
					</a>

					<!-- 등록날짜 -->
					<a href="${detailUrl}" class="hover:underline">
						<span class="badge">등록날짜</span>
						<span class="text-gray-600 text-light">${articles.regDate}</span>
					</a>

					<!-- 수정날짜 -->
					<c:if test="${articles.updateDate != articles.regDate}">
						<a href="${detailUrl}" class="hover:underline">
							<span class="badge">수정날짜</span>
							<span class="text-gray-600 text-light">${articles.updateDate}</span>
						</a>
					</c:if>

				</div>
			</div>

		</c:forEach>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>