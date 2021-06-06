<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.sbs.untact.util.Util"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<script>
	param.boardId = parseInt("${board.id}");
</script>

<section class="section-1">

	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">

		<div>
			<span class="text-xl font-bold">최근 게시물</span>
		</div>

		<c:forEach items="${LatestArticleByBoardNameFree}" var="articles">
			<div class="mt-5">
				<span class="badge badge-warning">
					<a href="/usr/article/list?boardId=${articles.boardId}">${articles.extra__boardName}</a>
				</span>
				<span class="badge badge-outline">
					<a href="/usr/article/detail?id=${articles.id}">제목</a>
				</span>
				<a href="/usr/article/detail?id=${articles.id}">
					<span class="ml-2">${articles.title}</span>
				</a>
			</div>
		</c:forEach>


		<c:forEach items="${LatestArticleByBoardNameNotice}" var="articles">
			<div class="mt-5">
				<span class="badge badge-info">
					<a href="/usr/article/list?boardId=${articles.boardId}">${articles.extra__boardName}</a>
				</span>
				<span class="badge badge-outline">
					<a href="/usr/article/detail?id=${articles.id}">제목</a>
				</span>
				<a href="/usr/article/detail?id=${articles.id}">
					<span class="ml-2">${articles.title}</span>
				</a>
			</div>
		</c:forEach>

	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>