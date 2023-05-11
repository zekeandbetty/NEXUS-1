<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script type="text/javascript" src="js/jquery/jquery-3.1.1.min.js"></script>
<style>
.assigneeboxes li {
	list-style: none;
}

input.inputCk+label {
	cursor: pointer;
}

.assigneeboxes li input[type="checkbox"] {
	display: inline-block;
	width: 16px;
	height: 16px;
	margin-right: 10px;
	vertical-align: middle;
	position: relative;
	top: -1px;
}
</style>




</style>




<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/i18n/defaults-*.min.js"></script>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/issue_select.css">
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/issue_mini.js"></script>

<!-- 알람 종 js -->
<script src="${pageContext.request.contextPath}/resources/js/alarm.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/alarmSocket.js"></script>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>


</head>

<body>

	<jsp:include page="../common/template.jsp" />






	<div class="container total-box" style="margin-left: 0px; margin-right: 0px;">

		<form action="createIssue.mi" method="post" id="issueEnrollForm">

			<input type="text" class="form-control issuetitle" id="isTitle" name="title" placeholder="이슈 제목 입력" autofocus>



			<input type="hidden" name="issueNo" value="">
			<input type="hidden" name="userName" value="${loginUser.userName}">
			<input type="hidden" name="userNo" value="${loginUser.userNo}">
			<input type="hidden" name="assignees" value="">
			<input type="hidden" name="newTitle" value="">


			<div class="why">
				<div class="editor-wrapper">
					<div id="editor"></div>

					<input type="hidden" name="body" value="">

					<div class="btn-box">
						<br>
						<button type="submit" class="btn btn-outline-primary" id="btn1">제출하기</button>


					</div>
				</div>
		</form>
	</div>




	<div class="editor-label">






		<div class="mb-3">
			<label for="defaultSelect" class="form-label">이슈 담당자</label>

			<select id="defaultSelect" class="form-select" name="issueAss">
				<option>이슈 담당자</option>
				<c:forEach var="r" items="${RepoMembers }">
					<option value="${r.userName }">${r.userName}</option>
				</c:forEach>
			</select>
		</div>


		<div class="mb-3">
			<label for="defaultSelect" class="form-label">라벨</label>
			<select id="defaultSelect" class="form-select" name="issueLabel">
				<option>라벨</option>
				<c:forEach var="l" items="${lList }">
					<option value="${l.name }">${l.name }</option>
				</c:forEach>
			</select>
		</div>






		<div class="mb-3">
			<label for="defaultSelect" class="form-label">마일스톤</label>
			<select id="defaultSelect" class="form-select" name="milestone">
				<option>마일스톤</option>
				<option value="1" type="checkbox">One</option>
				<option value="2" type="checkbox">Two</option>
				<option value="3" type="checkbox">Three</option>
			</select>
		</div>




		<div id="issueEditArea" class="menulist col-md-3">


			<ul class="list-unstyled users-list m-0 avatar-group d-flex align-items-center">

				<li data-bs-toggle="tooltip" data-popup="tooltip-custom" data-bs-placement="top" class="avatar avatar-xs pull-up" title="${assignee}"><img src="${assigneeProfiles[loop.index]}" alt="" class="rounded-circle" /></li>

			</ul>
			<!-- 	        이슈 담당자 menubox 시작 -->
			<div class="menubox card">
				<div class="menubox-header dropdown">
					<button class="btn dropdown-toggle" type="button" id="issue-assignee-btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<span>담당자</span> <i class="icon-settings menu-icon"></i>

					</button>
					<div class="assigneeboxes dropdown-menu" aria-labelledby="issue-assignee-btn">
						<ul>

							<c:forEach var="r" items="${RepoMembers }">
								<li><input type="checkbox" id="${r.userName}-checkbox" class="inputCk" value="${r.userName }" /> <label for="${r.userName}-checkbox">${r.userName}</label></li>
							</c:forEach>


						</ul>
					</div>
				</div>

			</div>




		</div>
		<!-- editor-label -->

	</div>

	<script>

            var editor = new toastui.Editor({
                el: document.querySelector('#editor'),
                height: '100%',
                initialEditType: 'markdown'

            });
            var markdownValue = editor.getMarkdown();


      


            
		$(document).ready(function() {
		    $('#issueEnrollForm').submit(function() {
		    	
		   
		    	
		        var markdown = editor.getMarkdown();
		        $("input[name='body']").val(markdown);
		    	
		    	
		        var selectedAssignee = $(".form-select option:selected").val();
		        $('input[name="assignees"]').val(selectedAssignee);
		        
		        
		        return true;
		    });
		});


		$("#btn1").click(function() {
			
			
			var title = $("#isTitle").val();
	    	
			  const userNo = "${loginUser.userNo}";
			  const userName = "${loginUser.userName}";
			  // const issueNumber = "${issueNumber}";
			  // const authorName = "${authorName}";
			  const profile = "${loginUser.profile}";
			  // const contextPath = "${contextPath}";
			  const newTitle = title;

		
			  console.log(newTitle);

			  let issueSocket = new SockJS("http://localhost:8010/nexus/issue");

			 

			    const message = {
			      newTitle: newTitle,
			      userNo: userNo,
			      userName: userName,
			      profile: profile,
			    };
			    issueSocket.send(JSON.stringify(message));

			    console.log("aaaaaaaa");
			
		});  
	

            
        </script>








</body>

</html>


