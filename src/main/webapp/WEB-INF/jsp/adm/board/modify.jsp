<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<%@ page import="com.sbs.untact.util.Util"%>

<!-- lodash -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>

<script>
const BoardModify_checkAndSubmitDone = false;

let ModifyForm__validName = '';

//중복체크 함수 ajax
function ModifyForm__checkNameDup(obj) {
	
	const form = $('.formName').get(0);
	
	form.name.value = form.name.value.trim();
	
	if (form.name.value.length == 0) {
		return;
	}
	
	$.get(
		'getNameDup',
		{
			name:form.name.value
		},
		function(data) {
			
			let colorClass = 'text-green-500';
			
			if ( data.fail ) {	
				colorClass = 'text-red-500';
			}
			
			$('.NameInputMsg').html("<span class='" + colorClass + "'>" + data.msg + "</span>");
			
			if ( data.fail ) {
				form.name.focus();
			}
			
			else {
				ModifyForm__validName = data.body.name;
			}
			
		
		},
		
		'json'
		
	);

}
	function BoardModify_checkAndSubmit(form) {

		if (BoardModify_checkAndSubmitDone) {
			return;
		}

		form.name.value = form.name.value.trim();
		
		if (form.name.value.length == 0) {
			alert('이름을 입력해주세요.');
			form.name.focus();
			
			return;
		}
		
		if ( form.name.value != ModifyForm__validName ) {
			alert('이름 중복체크를 해주세요.');
			form.name.focus();
			
			return;
		}
		
		form.submit();
		BoardModify_checkAndSubmitDone = true;
	}


	$(function() {
		$('.inputName').change(function() {
			ModifyForm__checkNameDup();
			});
		
		$('.inputName').keyup(_.debounce(ModifyForm__checkNameDup, 1000));
 
	});
	
</script>

<section class="section-1">
		<form class="formName bg-white shadow-md rounded container mx-auto p-8 mt-8"
			onsubmit="BoardModify_checkAndSubmit(this); return false;" action="doModify" method="POST">
			<input type="hidden" name="id" value="${board.id}" />
			<input type="hidden" name="redirectUrl" value="${param.redirectUrl}" />
			
			<div class="form-row flex flex-col lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>코드</span>
				</div>
				<div class="lg:flex-grow">${board.code}</div>
			</div>


			<!-- name -->
			<div class="form-row flex flex-col my-5 lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>이름</span>
				</div>
				<div class="lg:flex-grow">
					<input
						class="inputName shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
						autofocus="autofocus" type="text" name="name" maxlength="20"
						value="${board.name}" />
				</div>
			</div>
			
			<!-- 중복여부를 ajax로 물어봄 -->
			<div class="NameInputMsg ml-2 mb-2"></div>
				
			<div class="flex flex-col my-3 md:flex-row">
				<div class="p-1 md:flex-grow">
					<div class="btns">
						<input type="submit"
							class="btn-primary bg-blue-500 text-white font-bold py-2 px-4 rounded"
							value="수정">
						<input onclick="history.back();" type="button"
							class="btn-info bg-red-600 text-white font-bold py-2 px-4 rounded"
							value="취소">
					</div>
				</div>
			</div>
		</form>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
