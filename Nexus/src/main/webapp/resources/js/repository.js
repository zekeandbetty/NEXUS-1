

$(function(){

    // active 클래스 를 repository로 옮기기
    $(".active").removeClass("active");
    $("#repository").addClass("active")

    $("#enroll").text("news repository")
    $("#enroll").css("visibility", "visible")
})

