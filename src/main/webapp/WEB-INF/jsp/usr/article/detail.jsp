<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.sbs.untact.util.Util"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<c:set var="fileInputMaxCount" value="10" />

<section class="section-1">

	<div class="section-article-detail">

		<div class="container mx-auto">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

				<div class="card-title bg-white">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>${article.id}번 게시물</span>
				</div>

				<div class="p-5">

					<!-- 제목 -->
					<div class="mt-7">
						<span class="badge badge-outline">제목</span>
						<div class="break-all mt-1 ml-1">${article.title}</div>
					</div>

					<!-- 번호 -->
					<div
						class="mt-3 grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">
						<div>
							<span class="badge badge-primary">번호</span>
							<span>${article.id}</span>
						</div>

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

						<!-- 수정날짜 -->
						<div>
							<span class="badge">수정날짜</span>
							<span class="text-gray-600 text-light">${article.updateDate}</span>
						</div>
					</div>

					<!-- 본문 -->
					<div class="mt-6">
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

					<div class="flex plain-link-wrap gap-3 mt-4">

						<div class="flex"></div>

						<div class="flex-grow"></div>
						<!-- 좋아요 -->

						<div title="좋아요">
							<a href="doLike?relTypeCode=article&relId=${article.id}&memberId=${loginedMember.id}"
								class="flex plain-link">

								<c:choose>
									<c:when test="${like.memberId == loginMemberId}">
										<span class="text-pink-500">
											<i class="fas fa-heart"></i>
											${Util.numberFormat(totleItemsCountByLike)}
										</span>
									</c:when>

									<c:otherwise>
										<span class="text-pink-500">
											<i class="far fa-heart"></i>
											${Util.numberFormat(totleItemsCountByLike)}
										</span>
									</c:otherwise>

								</c:choose>

							</a>
						</div>
						<!-- 만약에 좋아요의 멤버아이디와 아이디가 같으면 채우진 하트 아니면 빈하트 -->

						<c:if test="${article.memberId == loginMemberId}">
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

		<div class="container mx-auto mt-4">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">
				<div id="vue-app__reply-box">
					<div class="card-title bg-white">
						<i class="far fa-comments"></i>
						<span class="text-lg">댓글</span>
					</div>
					<div>
						<!-- 댓글 입력 시작 -->
						<form class="grid form-type-1" action="doReply" method="POST"
							enctype="multipart/form-data">
							<div class="form-control">
								<input name="body" type="text" 
									class="input input-bordered">
							<input type="submit" class="btn mb-1"
								value="작성">
							</div>
						</form>

						<div class="mt-4 btn-wrap gap-1">
							<!-- 댓글 입력 끝 -->

							<div class="item-bt-1">
								<div v-for="reply in filteredReplies">
									<div class="flex py-5 px-4">
										<div class="flex-shrink-0">
											<img
												class="w-10 h-10 object-cover rounded-full shadow mr-2 cursor-pointer"
												alt="User avatar"
												src="https://images.unsplash.com/photo-1477118476589-bff2c5c4cfbb?ixlib=rb-1.2.1&amp;ixid=eyJhcHBfaWQiOjEyMDd9&amp;auto=format&amp;fit=crop&amp;w=200&amp;q=200">
										</div>
										<div class="flex-grow px-1">
											<div class="flex text-gray-400 text-light text-sm">
												<spqn>{{reply.extra__writer}}</spqn>
												<span class="mx-1">·</span>
												<spqn>{{reply.updateDate}}</spqn>
											</div>
											<div class="break-all">{{reply.body}}</div>
											<div class="mt-1">
												<span>
													<span>업</span>
													<span>5,600</span>
												</span>
												<span class="ml-1">
													<span>다</span>
													<span>5,600</span>
												</span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>