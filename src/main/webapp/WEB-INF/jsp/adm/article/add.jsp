<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<section class="section-1">
	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<span class="text-3xl text-black font-bold">게시물 추가</span>
		<form action="doAdd" method="POST">
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

			<input type="submit"
				class="btn-primary bg-blue-500 hover:bg-blue-dark text-white font-bold py-1 px-4 rounded"
				value="작성" />
			<input type="button"
				class="btn-info bg-red-500 hover:bg-blue-dark text-white font-bold py-1 px-4 rounded"
				value="취소" onclick="history.back();" />
		</form>
	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
