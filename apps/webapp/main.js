function bump() {
    var numberDiv = document.getElementById('numberDiv');
    var letterDiv = document.getElementById('letterDiv');
    var xhr = new XMLHttpRequest();
    var url = apiIncrementer;
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

function bumpBasic() {
    var numberDiv = document.getElementById('numberDiv');
    var letterDiv = document.getElementById('letterDiv');
    var xhr = new XMLHttpRequest();
    var url = apiIncrementNoLd;
    xhr.open("POST", url, true);
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            res = JSON.parse(xhr.responseText);
            numberDiv.innerText = res.number;
            letterDiv.innerText = res.letter;
        }
    }
    xhr.send();
}


function bumpClean() {
    var numberDiv = document.getElementById('numberDiv');
    var letterDiv = document.getElementById('letterDiv');
    var xhr = new XMLHttpRequest();
    var url = apiIncrementNoLd;
    xhr.open("POST", url, true);
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            res = JSON.parse(xhr.responseText);
            numberDiv.innerText = res.number;
            letterDiv.innerText = res.letter;
        }
    }
    xhr.send();
}


function getData() {
    var numberDiv = document.getElementById('numberDiv');
    var letterDiv = document.getElementById('letterDiv');
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
