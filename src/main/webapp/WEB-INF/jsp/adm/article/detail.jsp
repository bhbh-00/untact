<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.sbs.untact.util.Util"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<!-- lodash -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>

<c:set var="fileInputMaxCount" value="10" />

<!-- 댓글 from -->
<script>
	const addReply_checkAndSubmitDone = false;

	function addReply_checkAndSubmit(form) {

		if (addReply_checkAndSubmitDone) {

			return;
		}

		form.body.value = form.body.value.trim();

		if (form.body.value.length == 0) {
			alert('댓글을 입력해주세요.');
			form.body.focus();

			return;
		}

		addReply_checkAndSubmitDone = true;
	}
</script>

<section class="section-1">

	<div class="section-article-detail">

		<div class="container mx-auto">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

				<div class="card-title bg-white">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					
					<!-- 제목 -->
					<div>
						<span>${article.title}</span>
					</div>
				</div>

				<div class="p-5">

					<div class="mt-2">
						<!-- 번호 -->
						<span class="badge badge-primary">No. ${article.id}</span>
					</div>

					<!-- 본문 -->
					<div class="my-10">
						<span class="badge badge-outline">본문</span>
						<div class="mt-3">
							<c:forEach begin="1" end="${fileInputMaxCount}" var="inputNo">
								<c:set var="fileNo" value="${String.valueOf(inputNo)}" />
								<c:set var="file"
									value="${article.extra.file__common__attachment[fileNo]}" />
									${file.mediaHtml}
							</c:forEach>
						</div>
						<div class="mt-3 break-all ml-1">${article.body}</div>
					</div>

					<div
						class="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">

						<!-- 작성자 -->
						<div>
							<span class="badge badge-accent">작성자</span>
							<span>${article.extra__writer}</span>
						</div>

						<!-- 등록날짜 -->
						<div>
							<span class="badge">등록날짜</span>
							<span class="text-gray-600 text-light">${article.regDate}</span>
						</div>

						<c:if test="${article.updateDate != article.regDate}">
							<!-- 수정날짜 -->
							<div>
								<span class="badge">수정날짜</span>
								<span class="text-gray-600 text-light">${article.updateDate}</span>
							</div>
						</c:if>
					</div>

					<div class="flex plain-link-wrap gap-3 mt-4">

						<div class="flex"></div>

						<div class="flex-grow"></div>

						<!-- 좋아요 -->
						<!-- 만약에 좋아요의 멤버아이디와 아이디가 같으면 채우진 하트 아니면 빈하트 -->
						<c:choose>
							<c:when test="${like.memberId == loginedMember.id}">
								<a href="../like/doDelete?id=${like.id}" class="flex plain-link">
									<span class="text-pink-500">
										<!-- 하트 -->
										<i class="fas fa-heart"></i>
										${Util.numberFormat(totleItemsCountByLike)}
									</span>
								</a>
							</c:when>
							<c:otherwise>
								<form class="grid form-type-1" action="../like/doLike"
									method="POST" enctype="multipart/form-data">

									<input type="hidden" name="relTypeCode" value="article" />
									<input type="hidden" name="relId" value="${article.id}" />
									<input type="hidden" name="memberId"
										value="${loginedMember.id}" />
									<input type="hidden" name="redirectUrl"
										value="../article/detail?id=${article.id}" />
									<input type="hidden" name="like" value="like" />

									<button type="submit">
										<c:choose>
											<c:when test="${like.memberId == loginedMember.id}">
												<span class="text-pink-500">
													<!-- 하트 -->
													<i class="fas fa-heart"></i>
													${Util.numberFormat(totleItemsCountByLike)}
												</span>
											</c:when>

											<c:otherwise>
												<span class="text-pink-500">
													<!-- 빈하트 -->
													<i class="far fa-heart"></i>
													${Util.numberFormat(totleItemsCountByLike)}
												</span>
											</c:otherwise>

										</c:choose>
									</button>
								</form>
							</c:otherwise>
						</c:choose>

						<c:if test="${article.memberId == loginedMember.id}">
							<!-- 수정 -->
							<a href="modify?id=${article.id}" class="flex plain-link">
								<span>
									<i class="fas fa-edit"></i>
								</span>
								<span>수정</span>
							</a>

							<!-- 삭제 -->
							<a onclick="if ( !confirm('삭제하시겠습니까?') ) return false;"
								href="doDelete?id=${article.id}" class="flex plain-link">
								<span class="text-red-500">
									<i class="fas fa-trash"></i>
									<span>삭제</span>
								</span>
							</a>
						</c:if>
					</div>

				</div>
			</div>
		</div>
	</div>

	<div class="container mx-auto mt-4">
		<div class="card bordered shadow-lg item-bt-1-not-last-child bg-white">
			<div id="vue-app__reply-box">
				<div class="card-title bg-white">
					<i class="far fa-comments"></i>
					<span class="text-lg">댓글</span>
				</div>

				<div class="relative">
					<!-- 댓글 입력 시작 -->
					<form class="grid form-type-1" action="../reply/doAdd"
						method="POST" enctype="multipart/form-data"
						onsubmit="addReply_checkAndSubmit(this); return false;">

						<input type="hidden" name="relTypeCode" value="article" />
						<input type="hidden" name="relId" value="${article.id}" />
						<input type="hidden" name="memberId" value="${loginedMember.id}" />
						<input type="hidden" name="redirectUrl"
							value="../article/detail?id=${article.id}" />

						<input name="body" type="text" style="border-radius: 25px"
							placeholder="댓글을 입력해주세요." autocomplete="off"
							class="w-full py-2 pl-4 pr-10 text-sm bg-gray-100 border border-transparent appearance-none rounded-tg placeholder-gray-400
								focus:bg-white focus:outline-none focus:border-blue-500 focus:text-gray-900 focus:shadow-outline-blue">

						<button type="submit" class="absolute top-2 right-5">
							<i class="fas fa-pen"></i>
						</button>


					</form>
					<!-- 댓글 입력 끝 -->
					<div class="mt-4 btn-wrap gap-1"></div>

					<!-- 댓글 List -->
					<c:forEach items="${replys}" var="reply">
						<div class="item-bt-1">
							<div class="flex py-5 px-4">
								<div class="flex-shrink-0">
									<img
										class="w-11 h-11 object-cover rounded-full shadow mr-2 cursor-pointer"
										onerror="${loginedMember.profileFallbackImgOnErrorHtmlAttr}"
										src="${loginedMember.profileImgUrl}">
								</div>
								<div class="flex-grow px-1">

									<div class="flex text-gray-500 text-light text-sm">
										<span>${reply.extra__writer}</span>
										<span class="mx-1">·</span>
										<span>${reply.updateDate}</span>
									</div>

									<div class="flex">

										<div class="font-medium">
											<span>${reply.body}</span>
										</div>

										<div class="flex-grow"></div>

										<div class="flex text-sm">

											<c:if test="${ loginedMember.id == reply.memberId}">

												<!-- 수정 -->
												<a href="/usr/reply/modify?id=${reply.id}"
													class="flex plain-link mr-2">
													<span>
														<i class="fas fa-edit"></i>
													</span>
													<span class="hidden md:block">수정</span>
												</a>

												<!-- 삭제 -->
												<a onclick="if ( !confirm('삭제하시겠습니까?') ) return false;"
													href="/usr/reply/doDelete?id=${reply.id}"
													class="flex plain-link">
													<span class="text-red-500">
														<i class="fas fa-trash"></i>
														<span class="">삭제</span>
													</span>
												</a>

											</c:if>
										</div>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>

				</div>
			</div>
		</div>
	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>