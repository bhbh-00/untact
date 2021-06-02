<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<section class="section-1">

	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<div>
			<span class="badge badge-warning">${LatestArticleByBoardNameFree.extra__boardName}</span>
			<span class="ml-1">최근 게시물</span>
		</div>
		<div class="mt-3">
			<span class="badge badge-outline">제목</span>
			<a href="/usr/article/detail?id=${LatestArticleByBoardNameFree.id}">
				<span class="ml-2">${LatestArticleByBoardNameFree.title}</span>
			</a>
		</div>
	</div>

	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<div>
			<span class="badge badge-info">${LatestArticleByBoardNameNotice.extra__boardName}</span>
			<span class="ml-1">최근 게시물</span>
		</div>
		<div class="mt-3">
			<span class="badge badge-outline">제목</span>
			<a href="/usr/article/detail?id=${LatestArticleByBoardNameNotice.id}">
				<span class="ml-2">${LatestArticleByBoardNameNotice.title}</span>
			</a>
		</div>
	</div>

	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<div>
			<span>좋아요 많은 게시물</span>
		</div>
		<div class="mt-3">
			<span class="badge badge-info">${totleCountLikeByArticle.extra__boardName}</span>
			<span class="badge badge-outline">제목</span>
			<a href="/usr/article/detail?id=${totleCountLikeByArticle.id}">
				<span class="ml-2">${totleCountLikeByArticle.title}</span>
			</a>
		</div>
	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>