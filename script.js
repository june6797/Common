// 동의 항목 펼침 기능
function toggleContent(id) {
  const el = document.getElementById(id);
  el.style.display = el.style.display === "block" ? "none" : "block";
}

// 전체 동의 시 필수 항목 모두 체크
document.addEventListener("DOMContentLoaded", () => {
  const agreeAll = document.getElementById("agree-all");
  const requiredBoxes = document.querySelectorAll(".required-term");

  agreeAll.addEventListener("change", function () {
    requiredBoxes.forEach((box) => {
      box.checked = this.checked;
    });
  });
});
