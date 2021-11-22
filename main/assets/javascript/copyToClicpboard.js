    function CopyToClipboard(pass,link) {
    var input = document.createElement('input');
    input.value = pass;
    document.body.appendChild(input);
    input.select();
    document.execCommand("copy");
    location.replace(link);
    document.body.removeChild(input);
    }