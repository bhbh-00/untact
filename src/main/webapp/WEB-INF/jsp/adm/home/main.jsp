<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.sbs.untact.util.Util"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<script>
	param.boardId = parseInt("${board.id}");
</script>

<section class="section-home-main">

	<div
		class="container mx-auto bg-white card bordered shadow-lg p-5 mb-5 relative">

		<div class="items-center ml-2">
			<span class="text-xl font-bold">
				<span>최근 게시물</span>
			</span>
		</div>

		<div>
			<c:forEach items="${LatestArticleByBoardNameFree}" var="articles">

				<!-- 반복문 안에 임시변수를 넣어둘 수 있음! c:set -->
				<c:set var="detailUrl" value="../article/detail?id=${articles.id}" />

				<div class="p-4">

					<!-- 게시판 번호 -->
					<a href="${detailUrl}" class="cursor-pointer hover:underline">
						<span class="badge badge-info">${articles.extra__boardName}</span>
					</a>

					<!-- 게시물 번호 -->
					<a href="${detailUrl}" class="hover:underline">
						<span class="text-base">No.${articles.id}</span>
					</a>

					<div
						class="mt-3 grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">

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
				<hr>
			</c:forEach>
		</div>

		<div>
			<c:forEach items="${LatestArticleByBoardNameNotice}" var="articles">

				<!-- 반복문 안에 임시변수를 넣어둘 수 있음! c:set -->
				<c:set var="detailUrl" value="detail?id=${articles.id}" />

				<div class="p-4">

					<!-- 게시판 번호 -->
					<a href="${detailUrl}" class="cursor-pointer hover:underline">
						<span class="badge badge-info">${articles.extra__boardName}</span>
					</a>

					<!-- 게시물 번호 -->
					<a href="${detailUrl}" class="hover:underline">
						<span class="text-base">No.${articles.id}</span>
					</a>

					<div
						class="mt-3 grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">

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
				<hr>
			</c:forEach>
		</div>
	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>