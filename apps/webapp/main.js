function bump() {
    var xhr = new XMLHttpRequest();
    var url = apiIncrementer;
    xhr.open("POST", url, true);
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            getData();
        }
    }
    xhr.send();
}

function getData() {
    numberDiv = document.getElementById('numberDiv');
    letterDiv = document.getElementById('letterDiv');
    var xhr = new XMLHttpRequest();
    var url = apiDBValues;
    xhr.open("POST", url, true);
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            res = JSON.parse(xhr.responseText);
            numberDiv.innerText = res.number;
            letterDiv.innerText = res.letter;
        }
    }
    xhr.send();
}

window.addEventListener('load', function () {
    getData();
});
