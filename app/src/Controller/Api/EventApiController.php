<?php

declare(strict_types=1);

namespace App\Controller\Api;

use App\Exception\FieldRequiredException;
use App\Repository\EventRepository;
use App\Request\EventRequest;
use App\Service\EventService;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;

class EventApiController extends AbstractApiController
{
    public function __construct(
        private EventService $eventService,
        private EventRepository $repository,
        private EventRequest $eventRequest
    ) {
    }

    public function getList(): JsonResponse
    {
        $events = $this->repository->findAll();

        return new JsonResponse($events);
    }

    public function getOne(array $params): JsonResponse
    {
        $id = $this->extractIdParam($params);
        $event = $this->repository->find($id);

        return new JsonResponse($event);
    }

    public function getTypes(): JsonResponse
    {
        $types = $this->eventService->getTypes();

        return new JsonResponse($types);
    }

    public function getEventsBySpace(array $params): JsonResponse
    {
        $id = $this->extractIdParam($params);
        $events = $this->repository->findEventsBySpaceId($id);

        return new JsonResponse($events);
    }

    public function post(): JsonResponse
    {
        $eventData = $this->eventRequest->validatePost();

        if (true === empty($eventData)) {
            throw new FieldRequiredException('Event data is required.');
        }

        $event = $this->eventService->create((object) $eventData);

        $responseData = [
            'id' => $event->getId(),
            'name' => $event->getName(),
            'shortDescription' => $event->getShortDescription(),
            'classificacaoEtaria' => $event->getMetadata('classificacaoEtaria'),
            'terms' => $event->getTerms(),
        ];

        return new JsonResponse($responseData, Response::HTTP_CREATED);
    }

    public function patch(array $params): JsonResponse
    {
        $id = $this->extractIdParam($params);
        $eventData = $this->eventRequest->validateUpdate();

        if (true === empty($eventData)) {
            throw new FieldRequiredException('Event data is required.');
        }

        $event = $this->eventService->update($id, (object) $eventData);

        return new JsonResponse($event, Response::HTTP_CREATED);
    }

    public function delete($params): JsonResponse
    {
        $event = $this->eventRequest->validateEventExistent($params);

        $this->repository->softDelete($event);

        return new JsonResponse([], Response::HTTP_OK);
    }
}
