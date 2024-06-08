<?php

declare(strict_types=1);

namespace App\Controller\Api;

use App\Exception\FieldRequiredException;
use App\Repository\AgentRepository;
use App\Request\AgentRequest;
use App\Service\AgentService;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;

class AgentApiController extends AbstractApiController
{
    public function __construct(
        private AgentService $agentService,
        private AgentRequest $agentRequest,
        private AgentRepository $repository
    ) {
    }

    public function getList(): JsonResponse
    {
        $agents = $this->repository->findAll();

        return new JsonResponse($agents);
    }

    public function getOne(array $params): JsonResponse
    {
        $id = $this->extractIdParam($params);

        return new JsonResponse(
            $this->repository->find($id)
        );
    }

    public function getTypes(): JsonResponse
    {
        return new JsonResponse(
            $this->agentService->getTypes()
        );
    }

    public function post(): JsonResponse
    {
        $agentData = $this->agentRequest->validatePost();

        if (true === empty($agentData['name'])) {
            throw new FieldRequiredException('name');
        }

        $agent = $this->agentService->create((object) $agentData);

        $responseData = [
            'id' => $agent->getId(),
            'name' => $agent->getName(),
            'shortDescription' => $agent->getShortDescription(),
            'terms' => $agent->getTerms(),
            'type' => $agent->getType(),
        ];

        return new JsonResponse($responseData, Response::HTTP_CREATED);
    }

    public function patch(array $params): JsonResponse
    {
        $id = $this->extractIdParam($params);
        $agentData = $this->agentRequest->validateUpdate();
        $agent = $this->agentService->update($id, (object) $agentData);

        return new JsonResponse($agent, Response::HTTP_CREATED);
    }

    public function delete(array $params): JsonResponse
    {
        $id = $this->extractIdParam($params);
        $this->agentService->discard($id);

        return new JsonResponse(status: Response::HTTP_NO_CONTENT);
    }
}
