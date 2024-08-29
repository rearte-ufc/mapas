<?php

declare(strict_types=1);

use App\Controller\Api\WelcomeApiController;
use Symfony\Component\HttpFoundation\Request;
use App\Controller\Api\OpportunityApiController;

$routes = [
    '/api' => [
        Request::METHOD_GET => [WelcomeApiController::class, 'index'],
    ],
    '/api/v2' => [
        Request::METHOD_GET => [WelcomeApiController::class, 'index'],
        Request::METHOD_POST => [WelcomeApiController::class, 'create'],
        Request::METHOD_DELETE => [WelcomeApiController::class, 'delete'],
    ],
    '/api/findOpportunitiesModels' => [
        Request::METHOD_GET => [OpportunityApiController::class, 'findOpportunitiesModels'],
    ]
];

$files = glob(__DIR__.'/api/*.php');

foreach ($files as $file) {
    $routes = [...$routes, ...require $file];
}

return $routes;
