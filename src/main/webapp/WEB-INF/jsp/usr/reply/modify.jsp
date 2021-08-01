<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<%@ page import="com.sbs.untact.util.Util"%>

<script>
	ReplyModify_checkAndSubmitDone = false;

	function ReplyModify_checkAndSubmit(form) {

		if (ReplyModify_checkAndSubmitDone) {
			return;
		}

		form.body.value = form.body.value.trim();

		if (form.body.value.length == 0) {
			alert('댓글을 입력해주세요.');
			form.body.focus();

			return;
		}

		form.submit();
		ReplyModify_checkAndSubmitDone = true;
	}
</script>

<section class="section-adm-reply-modify">

	<div
		class="container mx-auto bg-white card bordered shadow-lg px-5 pt-5 pb-3">
				<div>
					<div class="card-title bg-white">
						<a href="javascript:history.back();" class="cursor-pointer">
							<i class="fas fa-chevron-left"></i>
						</a>
						<span class="text-lg">댓글 수정</span>
					</div>

					<div class="px-4 py-4 relative">
						<form onsubmit="ReplyModify_checkAndSubmit(this); return false;"
							action="doModify" method="POST" enctype="multipart/form-data">
							<input type="hidden" name="id" value="${reply.id}" />
							<input type="hidden" name="redirectUrl"
								value="/usr/article/detail?id=${article.id}" />

							<input name="body" type="text" style="border-radius: 25px"
								value="${reply.body}" placeholder="댓글을 입력해주세요."
								autocomplete="off"
								class="w-full py-2 pl-4 pr-10 text-sm bg-gray-100 border border-transparent appearance-none rounded-tg placeholder-gray-400
								focus:bg-white focus:outline-none focus:border-blue-500 focus:text-gray-900 focus:shadow-outline-blue">

							<button type="submit" class="absolute top-6 right-10">
								<i class="fas fa-pen"></i>
							</button>

						</form>

					</div>
				</div>
			</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
