header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: GET, POST');

function curlRequest($curlUrl, $curlTable, $language){
    $ch = curl_init($curlUrl);
    $curlData = array("language" => $language, "table" => $curlTable);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($curlData));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    $curlResult = curl_exec($ch);
    curl_close($ch);
    return $curlResult;
}

$file = fopen("someFile.txt", "a");
fwrite($file, "Some message");
fclose($file);

if(isset($_POST['var'])){
    $var = filter_var($_POST['var'], FILTER_SANITIZE_STRING);
}
