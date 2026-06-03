$(function () {
    var courseId = $("form").attr("data-course-id");
    var $items = $("#materials-list li");

    if ($items.length === 0) {
        return;
    }

    $items.draggable({
        helper: "clone",
        revert: "invalid",
        cancel: "a"
    });

    $("#download-tray").droppable({
        accept: "#materials-list li",
        drop: function (event, ui) {
            var materialId = ui.draggable.attr("data-material-id");
            if (materialId && courseId) {
                window.location.href = "CourseMaterials.aspx?courseId=" + courseId + "&download=" + materialId;
            }
        }
    });
});
