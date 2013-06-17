<?php

// get settings from config file
$config = parse_ini_file('repoData/config/config.ini', true) or exit("Repository configuration is not set!");
$logFile = 'repoData/' . $config['logging']['path'] . $config['logging']['file']; // File to log auto pulls.

function_exists('exec') or die('Function exec is not available!');
exec('which git', $gitExec) or die('Git is not available!');

$gitPath  = substr($gitExec['0'], 0, -3);

// Get repository root directory
exec('git rev-parse --show-toplevel', $repoRoot);

// Change dir to repo's root directory
chdir($repoRoot[0]);

// Post receive GitHub web-hook of manual pull request
if($_REQUEST['payload']) {

    // Post receive GitHub web-hook
    try {
        // Decode payload JSON
        $payload = json_decode($_REQUEST['payload']);

    } catch(Exception $e) {
        exit(0);
    }

    // Check for branch definde in config (master/preview/production)
    if ($payload->ref === 'refs/heads/' . $config['repository']['branch']) {

        // Automatic git pull on branch defined in config
        // Redirect STDERR to /dev/null to suppress throwing GitHub pull confirmations to PHP's error.log
        exec($gitPath . 'git pull ' . $config['repository']['host'] . ':' . $config['repository']['owner'] . '/'
                . $config['repository']['name'] . '.git ' . $config['repository']['branch'] . ' 2>/dev/null', $output);

        // Prepare log data
        $timestamp = date_create_from_format('Y-m-d\TH:i:sP', $payload->head_commit->timestamp);
        $logData = $payload->head_commit->id . '(on ' . $config['repository']['branch'] . ') - ' . date("d.m.Y H:i:s", date_format($timestamp, 'U'))
                   . ' - ' . $payload->head_commit->message . ' - ' . $payload->head_commit->author->name ."\n";

        // Log automatic pulls
        file_put_contents($logFile, $logData, FILE_APPEND);
    }
} else {

    // Manual git pull on master branch
    header("Content-type: text/plain");   // Avoid accidental XSS
    echo "\n\n" . 'Initialising git pull request...' . "\n";
    echo 'Branch in use - ' . $config['repository']['branch'] . "\n\n";
    // Redirect STDERR to STDOUT to suppress throwing GitHub pull confirmations to PHP's error.log
    system($gitPath . 'git pull ' . $config['repository']['host'] . ':' . $config['repository']['owner'] . '/'
            . $config['repository']['name'] . '.git ' . $config['repository']['branch'] . ' 2>&1');
    echo "\n\n" . 'Manual request finished.' . "\n\n";
}
