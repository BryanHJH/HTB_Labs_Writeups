<?php
session_start();
if (!$_SESSION['username']) {
    header("Location: /index.php", TRUE, 301);
    exit();
}

if ($_SESSION['username'] !== 'a.corrales') {
    header("Location: /index.php", TRUE, 301);
    exit();
}

libxml_disable_entity_loader(false);

$xmlfile = file_get_contents('php://input');

$dom = new DOMDocument();
$dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);
$info = simplexml_import_dom($dom);
$name = $info->name;
$details = $info->details;
$date = $info->date;

echo "Event '$name' has been created.";
