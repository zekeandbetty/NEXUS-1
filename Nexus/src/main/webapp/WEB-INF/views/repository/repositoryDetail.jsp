<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<% String[] arr = {"bg-primary","bg-success", "bg-danger", "bg-warning", "bg-info"}; %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>

<!-- code Mirror -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/codemirror.min.js" integrity="sha512-8RnEqURPUc5aqFEN04aQEiPlSAdE0jlFS/9iGgUyNtwFnSKCXhmB6ZTNl7LnDtDWKabJIASzXrzD0K+LYexU9g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/javascript/javascript.min.js" integrity="sha512-I6CdJdruzGtvDyvdO4YsiAq+pkWf2efgd1ZUSK2FnM/u2VuRASPC7GowWQrWyjxCZn6CT89s3ddGI+be0Ak9Fg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/codemirror.min.css" integrity="sha512-uf06llspW44/LZpHzHT6qBOIVODjWtv4MxCricRxkzvopAlSWnTf6hpZTFxuuZcuNE9CBQhqE0Seu1CoRk84nQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/theme/darcula.min.css" integrity="sha512-kqCOYFDdyQF4JM8RddA6rMBi9oaLdR0aEACdB95Xl1EgaBhaXMIe8T4uxmPitfq4qRmHqo+nBU2d1l+M4zUx1g==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<!-- code Mirror Language-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/sql/sql.min.js" integrity="sha512-JOURLWZEM9blfKvYn1pKWvUZJeFwrkn77cQLJOS6M/7MVIRdPacZGNm2ij5xtDV/fpuhorOswIiJF3x/woe5fw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/clike/clike.min.js" integrity="sha512-l8ZIWnQ3XHPRG3MQ8+hT1OffRSTrFwrph1j1oc1Fzc9UKVGef5XN9fdO0vm3nW0PRgQ9LJgck6ciG59m69rvfg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/htmlmixed/htmlmixed.min.js" integrity="sha512-HN6cn6mIWeFJFwRN9yetDAMSh+AK9myHF1X9GlSlKmThaat65342Yw8wL7ITuaJnPioG0SYG09gy0qd5+s777w==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/css/css.min.js" integrity="sha512-rQImvJlBa8MV1Tl1SXR5zD2bWfmgCEIzTieFegGg89AAt7j/NBEe50M5CqYQJnRwtkjKMmuYgHBqtD1Ubbk5ww==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/javascript/javascript.min.js" integrity="sha512-I6CdJdruzGtvDyvdO4YsiAq+pkWf2efgd1ZUSK2FnM/u2VuRASPC7GowWQrWyjxCZn6CT89s3ddGI+be0Ak9Fg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/markdown/markdown.min.js" integrity="sha512-DmMao0nRIbyDjbaHc8fNd3kxGsZj9PCU6Iu/CeidLQT9Py8nYVA5n0PqXYmvqNdU+lCiTHOM/4E7bM/G8BttJg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/xml/xml.min.js" integrity="sha512-LarNmzVokUmcA7aUDtqZ6oTS+YXmUKzpGdm8DxC46A6AHu+PQiYCUlwEGWidjVYMo/QXZMFMIadZtrkfApYp/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/repositoryDetail.css">
<script src="${ pageContext.request.contextPath }/resources/js/repositoryDetail.js"></script>

</head>
<body>
	<jsp:include page="../common/template.jsp"/>
	
	<script>
		console.log('${map}')
		console.log("hhh")
	</script>
	
	<c:set var="array" value="${fn:split('bg-primary,bg-success,bg-danger,bg-warning,bg-info',',')}" />
	<c:set var="textarray" value="${fn:split('text-primary,text-success,text-danger,text-warning,text-info',',')}" />
    <div class="container-xxl flex-grow-1 container-p-y cpadding mt-5">
        <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-8">
                <div class="card mb-5">
                    <div class="row">
                        <div class="col-lg-7 col-md-7 col-sm-7">
                            <img src="resources/image/github_repo.png" id="repoImg" alt="">
                            <br>
                            <span id="repoPath">${repo.userName }/${repo.repoName }</span>
                        </div>
                        <div class="col-lg-5 col-md-5 col-sm-5">
                            <br>
                            <div class="progress mb-3">
                            <c:forEach var="value" items="${map.values() }" varStatus="status">
                                <div class="progress-bar ${array[status.index] } shadow-none" role="progressbar" style="width: ${value}%" aria-valuenow="15" aria-valuemin="0" aria-valuemax="100"></div>
                            </c:forEach>
                            </div>
                            
                            <c:forEach var="i" items="${map }" varStatus="status">
                            
                            	<p class="circle ${array[status.index] }"></p>
                                <h4> ${ i }%</h4>
                            
                            </c:forEach>
               
                        </div>

                    </div>
                </div>
                <input type="hidden" name="hiddenpath" id="hiddenpath" value="">
                <div class="card mb-5">
                    <div id="pathWrap">
                    	<span id="totalPath">${repo.userName}/<span class="origin" id="${repo.userName}/${repo.repoName}/contents">${repo.repoName}</span></span>
                        <br> <br>
                        
                       	<div class="clear">

                            <c:forEach var="i" items="${ list }">
                                
                                <c:choose>
                                    <c:when test="${i.type eq 'file' }">
                                        <div>
                                            <div class="row">
                                                <div class="col-lg-8">
                                                    <img alt="파일 이미지" src="resources/image/file.png" width="30px">
                                                    <span class="clcik1" id="${i.download_url }" target="_blank">${i.name }</span>

                                                </div>
                                                <div class="col-lg-4">
                                                    <span>${i.size}</span>
                                                </div>
                                            </div>
                                            
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div>
                                            <img alt="폴더 이미지" src="resources/image/folder.png" width="30px">
                                            <span class="folder">${i.name }</span>
                                            
                                        </div>
                                    </c:otherwise>
                                
                                </c:choose>
                                <hr>
                            </c:forEach> 

                        </div>

                       
                    </div>
                </div>

                <div class="card mdFile">

                    <div>

                        ${text}

                    </div>

                </div>
            </div>
            <div class="col-lg-4 col-md-4 col-sm-4">
                <div class="card mb-5">
                    <h2>NEXUS</h2>
                    <p>설명충 ....</p>
                </div>

                <div class="card mb-5">

                    <div style="width: 90%; margin: auto; margin-top: 10px; margin-bottom: 10px;">
                        <h3>프로젝트 관리자</h3>
                        <c:forEach var="i" items="${mList }">
                            <c:if test="${i.rollName eq 'admin' }">
                                <div style="display:flex; margin-left: 20px;">
                                    <img src="${i.profile}" alt="" width="50px" height="50px" style="border-radius: 100%; float: left; display: block;">
                                    <span style="line-height: 50px; margin-left: 10px;">${i.userName}</span>
    
                                </div>
    
                            </c:if>
                        </c:forEach>

                    </div>
                </div>

                <div class="card mb-5">

                    <div style="width: 90%; margin: auto; margin-top: 10px; margin-bottom: 10px;">
                        <h3>참여 멤버</h3>
                        <c:forEach var="i" items="${mList }">
                            
                            <div style="display:flex; margin-left: 20px;">
                                <img src="${i.profile}" alt="" width="50px" height="50px" style="border-radius: 100%; float: left; display: block;">
                                <span style="line-height: 50px; margin-left: 10px;">${i.userName}</span>

                            </div>
                            <br>
    
                          
                        </c:forEach>

                    </div>

                </div>
                
            </div>
        </div>
    </div>

    <button type="button" id="lmodal" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exLargeModal">
        Extra Large
      </button>

    <div class="modal fade" id="exLargeModal" tabindex="-1" style="display: none;" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLabel4">Code(안보일시 클릭한번 해주세요)</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <textarea id="batch_content"></textarea>
            <div class="modal-footer">
              <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                Close
              </button>
              
            </div>
          </div>
        </div>
      </div>
   
</body>
</html>