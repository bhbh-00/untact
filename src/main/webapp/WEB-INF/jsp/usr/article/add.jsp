<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<!-- lodash -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>


<!-- 첨부파일 갯수 조절 -->
<c:set var="fileInputMaxCount" value="10" />

<script>
	ArticleAdd__fileInputMaxCount = parseInt("${fileInputMaxCount}");
</script>

<script>
	ArticleAdd__submited = false;

	function ArticleAdd__checkAndSubmit(form) {
		// 이게 끝나면 폼 전송완료

		// 중복처리 안되게 하는
		if (ArticleAdd__submited) {
			alert('처리중입니다.');
			return;
		}

		// 기본적인 처리
		form.title.value = form.title.value.trim();
		if (form.title.value.length == 0) {
			alert('제목을 입력해주세요.');
			form.title.focus();
			return false;
		}

		form.body.value = form.body.value.trim();
		if (form.body.value.length == 0) {
			alert('내용을 입력해주세요.');
			form.body.focus();
			return false;
		}

		// 파일 용량 처리
		var maxSizeMb = 50; // 용량
		var maxSize = maxSizeMb * 1024 * 1024; // 50MB

		for (let inputNo = 1; inputNo <= ArticleAdd__fileInputMaxCount; inputNo++) {
			const input = form["file__article__0__common__attachment__" + inputNo];
			// form.file__article__0__common__attachment__1.files[0].size -> 사이즈 구하는 식

			if (input.value) {
				if (input.files[0].size > maxSize) {
					alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
					input.focus();

					return;
				}
			}
		}

		const startSubmitForm = function(data) {

			if (data && data.body && data.body.genFileIdsStr) {
				form.genFileIdsStr.value = data.body.genFileIdsStr;
			}

			for (let inputNo = 1; inputNo <= ArticleAdd__fileInputMaxCount; inputNo++) {
				const input = form["file__article__0__common__attachment__" + inputNo];
				input.value = '';
			}

			form.submit();
			// 폼 전송
		};

		// 파일 업로드가 끝나 있는 상태 => 파일 업로드이다.
		const startUploadFiles = function(onSuccess) {
			// onSuccess 변수라고 생각하면 됌
			var needToUpload = false;

			for (let inputNo = 1; inputNo <= ArticleAdd__fileInputMaxCount; inputNo++) {
				const input = form["file__article__0__common__attachment__" + inputNo];

				if (input.value.length > 0) {
					needToUpload = true;
					break;
					// 들어온게 0보다 크면 멈춰라
				}
			}

			if (needToUpload == false) {
				onSuccess();
				return;
			}

			// 파일 업로드를 해야할 시
			var fileUploadFormData = new FormData(form);

			// 구조는 무조건 외우면 됌!
			$.ajax({
				url : '/common/genFile/doUpload',
				data : fileUploadFormData,
				processData : false,
				contentType : false,
				dataType : "json",
				type : 'POST',
				success : onSuccess
			});
		}

		ArticleAdd__submited = true;

		startUploadFiles(startSubmitForm);
		//startUploadFiles만 실행 => ()는 변수라고 생각하면 됌
	}
</script>

<section class="section-article-add">

	<div class="section-article-write">
		<div class="container mx-auto">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">
				<div class="card-title">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>게시물 작성</span>
				</div>

				<div class="px-4 py-8">
					<form class="grid form-type-1"
						onsubmit="ArticleAdd__checkAndSubmit(this); return false;"
						action="doAdd" method="POST" enctype="multipart/form-data">

						<input type="hidden" name="genFileIdsStr" value="" />
						<input type="hidden" name="boardId" value="${param.boardId}" />

						<div class="form-control">
							<label class="cursor-pointer label"> 작성자 </label>
							<div class="plain-text">${param.extra__boardName}</div>
						</div>

						<div class="form-control">
							<label class="label">
								<span class="label-text">제목</span>
							</label>
							<input name="title" type="text" placeholder="제목"
								class="input input-bordered">
						</div>

						<div class="form-control">
							<label class="label">
								<span class="label-text">본문</span>
							</label>
							<textarea name="body" placeholder="본문"
								class="h-80 textarea textarea-bordered"></textarea>
						</div>

						<c:forEach begin="1" end="${fileInputMaxCount}" var="inputNo">

							<div class="form-control">
								<label class="label">
									<span class="label-text">본문 이미지 ${inputNo}</span>
								</label>
								<div>
									<input class="thumb-available"
										data-thumb-selector="next().next()" type="file"
										name="file__article__0__common__attachment__${inputNo}"
										placeholder="본문 이미지 ${inputNo}"
										accept="image/png, image/jpeg, image/png">
									<div class="mt-2"></div>
								</div>
							</div>
						</c:forEach>

						<div class="mt-4 btn-wrap gap-1">
							<input type="submit" class="btn btn-primary btn-sm mb-1"
								value="작성">

							<a href="list?" class="btn btn-sm mb-1" title="리스트 보기">
								<span>
									<i class="fas fa-list"></i>
								</span>
								&nbsp;
								<span>리스트</span>
							</a>
						</div>

					</form>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>