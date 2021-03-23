<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<!-- lodash -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>

<script>
	const BoardAdd_checkAndSubmitDone = false;

	let BoardAdd__validCode = '';
	let BoardAdd__validName = '';

	//중복체크 함수 ajax
	function AddForm__checkNameDup(obj) {

		const form = $('.formCodeAndName').get(0);

		form.code.value = form.code.value.trim();

		if (form.code.value.length == 0) {
			return;
		}
		
		form.name.value = form.name.value.trim();

		if (form.name.value.length == 0) {
			return;
		}

		$.get('getCodeAndNameDup', {
			name : form.name.value
		}, function(data) {

			let colorClass = 'text-green-500';

			if (data.fail) {
				colorClass = 'text-red-500';
			}

			$('.NameInputMsg').html("<span class='" + colorClass + "'>" + data.msg + "</span>");

			if (data.fail) {
				form.name.focus();
			}

			else {
				BoardAdd__validName = data.body.name;
			}

		},

		'json'

		);

	}
	
	function BoardAdd__checkAndSubmit(form) {
		// 이게 끝나면 폼 전송완료

		// 중복처리 안되게 하는
		if (BoardAdd_checkAndSubmitDone) {
			return;
		}

		// 기본적인 처리
		form.code.value = form.code.value.trim();
		if (form.code.value.length == 0) {
			alert('코드을 입력해주세요.');
			form.code.focus();
			return false;
		}
		
		if ( form.code.value != BoardAdd__validCode ) {
			alert('코드 중복체크를 해주세요.');
			form.code.focus();
			
			return;
		}

		form.name.value = form.name.value.trim();
		
		if (form.name.value.length == 0) {
			alert('이름을 입력해주세요.');
			form.name.focus();
			
			return;
		}
		
		if ( form.name.value != BoardAdd__validName ) {
			alert('이름 중복체크를 해주세요.');
			form.name.focus();
			
			return;
		}
		
		form.submit();
		BoardAdd_checkAndSubmitDone = true;
	}

	$(function() {
		$('.inputName').change(function() {
			AddForm__checkNameDup();
			});
		
		$('.inputName').keyup(_.debounce(AddForm__checkNameDup, 1000));
 
	});
	
</script>

<section class="section-1">
	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<form class="formCodeAndName" onsubmit="BoardAdd__checkAndSubmit(this); return false;"
			action="doAdd" method="POST" enctype="multipart/form-data">
			
			<!-- code -->
			<div class="form-row flex flex-col lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>코드</span>
				</div>
				<div class="lg:flex-grow">
					<input type="text" name="code" autofocus="autofocus"
						class="inputName form-row-input w-full rounded-sm" placeholder="코드을 입력해주세요." />
				</div>
			</div>
			
			<!-- 중복여부를 ajax로 물어봄 -->
			<div class="NameInputMsg ml-2 mb-2"></div>

			<!-- name -->
			<div class="form-row flex flex-col lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>이름</span>
				</div>
				<div class="lg:flex-grow">
					<input type="text" name="name" autofocus="autofocus"
						class="inputName form-row-input w-full rounded-sm" placeholder="이름을 입력해주세요." />
				</div>
			</div>
			
			<!-- 중복여부를 ajax로 물어봄 -->
			<div class="NameInputMsg ml-2 mb-2"></div>
			
			<div class="form-row flex flex-col lg:flex-row">
				<div class="lg:flex-grow">
					<div class="btns">
						<input type="submit"
							class="btn-primary bg-blue-500 hover:bg-blue-dark text-white font-bold py-2 px-4 rounded"
							value="작성">
						<input onclick="history.back();" type="button"
							class="btn-info bg-red-500 hover:bg-red-dark text-white font-bold py-2 px-4 rounded"
							value="취소">
					</div>
				</div>
			</div>
		</form>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>