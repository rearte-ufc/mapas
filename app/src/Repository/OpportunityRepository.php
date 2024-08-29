<?php

declare(strict_types=1);

namespace App\Repository;

use App\Enum\EntityStatusEnum;
use Doctrine\Persistence\ObjectRepository;
use MapasCulturais\Entities\AgentOpportunity;
use MapasCulturais\Entities\Opportunity;

class OpportunityRepository extends AbstractRepository
{
    private ObjectRepository $repository;

    public function __construct()
    {
        parent::__construct();
        $this->repository = $this->mapaCulturalEntityManager->getRepository(Opportunity::class);
    }

    public function findAll(): array
    {
        return $this->repository
            ->createQueryBuilder('opportunity')
            ->getQuery()
            ->getArrayResult();
    }

    public function find(int $id): ?Opportunity
    {
        return $this->repository->find($id);
    }

    public function save(Opportunity $opportunity): void
    {
        $this->mapaCulturalEntityManager->persist($opportunity);
        $this->mapaCulturalEntityManager->flush();
    }
    public function findOpportunitiesByAgentId(int $agentId): array
    {
        $queryBuilder = $this->getEntityManager()
            ->createQueryBuilder()
            ->select('ao')
            ->from(AgentOpportunity::class, 'ao')
            ->where('ao.ownerEntity = :agentId')
            ->andWhere('ao.parent is null')
            ->setParameter('agentId', $agentId);

        return $queryBuilder->getQuery()->getArrayResult();
    }
    public function softDelete(Opportunity $opportunity): void
    {
        $opportunity->setStatus(EntityStatusEnum::TRASH->getValue());
        $this->save($opportunity);
    }

    public function findOpportunitiesModels(): array {
        $app = \MapasCulturais\App::i();
        $em = $app->em;
        $queryBuilder = $em->createQueryBuilder()
            ->select(
                'o.id', 
                'o.name', 
                '(COUNT(p.id) + 2) AS numeroFases', 
                'o.registrationTo', 
                'o.registrationFrom', 
                'o.shortDescription AS descricao',
                'o.registrationProponentTypes AS tipoAgente'
            )
            ->from(Opportunity::class, 'o')
            ->leftJoin(Opportunity::class, 'p', 'WITH', 'p.parent = o.id')
            ->where('o.parent IS NULL')
            ->andWhere('o.status = -1')
            ->groupBy('o.id, o.name');
        
        $results = $queryBuilder->getQuery()->getArrayResult();

        foreach ($results as &$result) {
            if (isset($result['registrationTo']) && isset($result['registrationFrom'])) {
                $registrationTo = $result['registrationTo'];
                $registrationFrom = $result['registrationFrom'];

                if (!$registrationTo instanceof \DateTime) {
                    $registrationTo = new \DateTime($registrationTo);
                }
                if (!$registrationFrom instanceof \DateTime) {
                    $registrationFrom = new \DateTime($registrationFrom);
                }
            
                $interval = $registrationFrom->diff($registrationTo);
                $days = $interval->days;
                
                $result['tempoEstimado'] = "$days dias";
            } else {
                $result['tempoEstimado'] = 'N/A';
            }

            if (isset($result['tipoAgente'])){
                
                $result['tipoAgente'] = implode(', ', $result['tipoAgente']);
            }else {
                $result['tipoAgente'] = 'N/A';
            }
        }
        return $results;
    }

}