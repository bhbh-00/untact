<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<script>
ArticleAdd__submited = false;
function ArticleAdd__checkAndSubmit(form) {	
	// 중복처리 안되게 하는
	if ( ArticleAdd__submited ) {
		alert('처리중입니다.');
		return;
	}
	
	// 기본적인 처리
	form.title.value = form.title.value.trim();
	if ( form.title.value.length == 0 ) {
		alert('제목을 입력해주세요.');
		form.title.focus();
		return false;
	}
	form.body.value = form.body.value.trim();
	if ( form.body.value.length == 0 ) {
		alert('내용을 입력해주세요.');
		form.body.focus();
		return false;
	}
	
	// 파일 용량 처리
	var maxSizeMb = 50; // 용량
	var maxSize = maxSizeMb * 1024 * 1024; // 50MB
	if (form.file__article__0__common__attachment__1.value) {
		if (form.file__article__0__common__attachment__1.files[0].size > maxSize) {
			// form.file__article__0__common__attachment__1.files[0].size -> 사이즈 구하는 식
			alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
			form.file__article__0__common__attachment__1.focus();
			
			return;
		}
	}
	
	if (form.file__article__0__common__attachment__2.value) {
		if (form.file__article__0__common__attachment__2.files[0].size > maxSize) {
			alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
			form.file__article__0__common__attachment__2.focus();
			
			return;
		}
	}
	
	form.submit();
	ArticleAdd__submited = true;
}
</script>

<section class="section-1">
	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<span class="text-3xl text-black font-bold">게시물 추가</span>
		<form  onsubmit="ArticleAdd__checkAndSubmit(this); return false;" action="doAdd" method="POST" enctype="multipart/form-data">

			<input type="hidden" name="boardId" value="${ param.boardId }" />

			<div class="form-row flex flex-col lg:flex-row mt-8">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>제목</span>
				</div>
				<div class="p-1 lg:flex-grow">
					<input
						class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
						autofocus="autofocus" type="text" placeholder="제목을 입력해주세요."
						name="title" maxlength="20" />
				</div>
			</div>

			<div class="form-row flex flex-col lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>내용</span>
				</div>
				<div class="p-1 lg:flex-grow">
					<textarea name="body"
						class="shadow appearance-none border border-red rounded w-full py-2 px-3 text-grey-darker mb-3"
						autofocus="autofocus" placeholder="내용을 입력해주세요."></textarea>
				</div>
			</div>

			<div class="form-row flex flex-col lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>첨부파일1</span>
				</div>
				<div class="p-1 lg:flex-grow">
					<input type="file" class="form-row-input w-full rounded-sm"
						name="file__article__0__common__attachment__1" />
				</div>
			</div>

			<div class="form-row flex flex-col lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>첨부파일2</span>
				</div>
				<div class="p-1 lg:flex-grow">
					<input type="file" class="form-row-input w-full rounded-sm"
						name="file__article__0__common__attachment__2" />
				</div>
			</div>
			<div class="form-row flex flex-col lg:flex-row">
				<div class="btus">
					<input type="submit"
						class="btn-primary bg-blue-500 hover:bg-blue-dark text-white font-bold py-1 px-4 rounded"
						value="작성" />
					<input type="button"
						class="btn-info bg-red-500 hover:bg-blue-dark text-white font-bold py-1 px-4 rounded"
						value="취소" onclick="history.back();" />
				</div>
			</div>
		</form>
	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
