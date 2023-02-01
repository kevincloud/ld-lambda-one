function bumpLdDb() {
    var numberDiv = document.getElementById('numberDiv');
    var letterDiv = document.getElementById('letterDiv');
    var latencyDiv = document.getElementById('latency1Div');
    var xhr = new XMLHttpRequest();
    var url = apiIncrementer;
    var start;
    xhr.open("POST", url, true);
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            res = JSON.parse(xhr.responseText);
            numberDiv.innerText = res.number;
            letterDiv.innerText = res.letter;
            latency = window.performance.now() - start;
            latencyDiv.innerText = parseInt(latency).toString() + " ms";
        }
    }
    start = window.performance.now();
    xhr.send();
}

function bumpLd() {
    var numberDiv = document.getElementById('numberDiv');
    var letterDiv = document.getElementById('letterDiv');
    var latencyDiv = document.getElementById('latency2Div');
    var xhr = new XMLHttpRequest();
    var url = apiIncrementLd;
    var start;
    xhr.open("POST", url, true);
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            res = JSON.parse(xhr.responseText);
            numberDiv.innerText = res.number;
            letterDiv.innerText = res.letter;
            latency = window.performance.now() - start;
            latencyDiv.innerText = parseInt(latency).toString() + " ms";
        }
    }
    start = window.performance.now();
    xhr.send();
}

function bumpDb() {
    var numberDiv = document.getElementById('numberDiv');
    var letterDiv = document.getElementById('letterDiv');
    var latencyDiv = document.getElementById('latency3Div');
    var xhr = new XMLHttpRequest();
    var url = apiIncrementDb;
    var start;
    xhr.open("POST", url, true);
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            res = JSON.parse(xhr.responseText);
            numberDiv.innerText = res.number;
            letterDiv.innerText = res.letter;
            latency = window.performance.now() - start;
            latencyDiv.innerText = parseInt(latency).toString() + " ms";
        }
    }
    start = window.performance.now();
    xhr.send();
}


function bumpNone() {
    var numberDiv = document.getElementById('numberDiv');
    var letterDiv = document.getElementById('letterDiv');
    var latencyDiv = document.getElementById('latency4Div');
    var xhr = new XMLHttpRequest();
    var url = apiIncrementNone;
    var payload = "{\"mynumber\": \"" + numberDiv.innerText + "\",\"myletter\": \"" + letterDiv.innerText + "\"}"
    var start;
    xhr.open("POST", url, true);
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            res = JSON.parse(xhr.responseText);
            numberDiv.innerText = res.number;
            letterDiv.innerText = res.letter;
            latency = window.performance.now() - start;
            latencyDiv.innerText = parseInt(latency).toString() + " ms";
        }
    }
    start = window.performance.now();
    xhr.send(payload);

}


function getData() {
    var numberDiv = document.getElementById('numberDiv');
    var letterDiv = document.getElementById('letterDiv');
    var xhr = new XMLHttpRequest();
    var url = apiDBValues;
    xhr.open("POST", url, true);
    xhr.setRequestHeader('Content-type', 'application/json');
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
