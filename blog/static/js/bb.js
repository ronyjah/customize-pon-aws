// function updateProgress(progressBarElement, progressBarMessageElement, progress) {
//     progressBarElement.style.width = progress.percent + "%";
//     progressBarMessageElement.innerHTML = progress.current + ' of ' + progress.total + ' processed.';
//   }
  
//   var trigger = document.getElementById('progress-bar-trigger');
//   trigger.addEventListener('click', function(e) {
//     var bar = document.getElementById("progress-bar");
//     var barMessage = document.getElementById("progress-bar-message");
//     for (var i = 0; i < 11; i++) {
//       setTimeout(updateProgress, 500 * i, bar, barMessage, {
//         percent: 10 * i,
//         current: 10 * i,
//         total: 100
//       })
//     }
//   })

function updateProgress(progressBarElement, progressBarMessageElement, progress) {
    progressBarElement.style.width = progress.percent + "%";
    progressBarMessageElement.innerHTML = progress.current + ' of ' + progress.total + ' processed.';
  }
  
  var trigger = document.getElementById('progress-bar-trigger');
    var bar = document.getElementById("progress-bar");
    var barMessage = document.getElementById("progress-bar-message");
    for (var i = 0; i < 101; i++) {
      setTimeout(updateProgress, 100 * i, bar, barMessage, {
        percent: 1 * i,
        current: 1 * i,
        total: 100
      })
    }

var modelo = document.getElementById("produto");

function droop (){
  $().dropdown('update')
}
  