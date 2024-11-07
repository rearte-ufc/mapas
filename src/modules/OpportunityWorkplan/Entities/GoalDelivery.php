<?php
namespace OpportunityWorkplan\Entities;

use Doctrine\ORM\Mapping as ORM;

/**
 * 
 * @ORM\Table(name="registration_workplan_goal_delivery")
 * @ORM\Entity
 * @ORM\entity(repositoryClass="MapasCulturais\Repository")
 */
class GoalDelivery extends \MapasCulturais\Entity {


    /**
     *
     * @ORM\Id
     * @ORM\Column(type="integer")
     * @ORM\GeneratedValue(strategy="IDENTITY")
     */
    protected $id;

    /**
     * @var string
     *
     * @ORM\Column(name="name", type="string", length=50)
     */
    protected $name;

    /**
     * @var string
     *
     * @ORM\Column(name="description", type="string", length=255)
     */
    protected $description;

    /**
     * @var string
     *
     * @ORM\Column(name="type", type="string", length=50)
     */
    protected $type;

    /**
     * @var string
     *
     * @ORM\Column(name="segment_delivery", type="string", length=50)
     */
    protected $segmentDelivery;

    /**
     * @var string
     *
     * @ORM\Column(name="budget_action", type="string", length=50)
     */
    protected $budgetAction;

     /**
     * @var integer
     *
     * @ORM\Column(name="expected_number_people", type="integer")
     */
    protected $expectedNumberPeople;

    /**
     *
     * @ORM\Column(name="generate_revenue", type="boolean")
     */
    protected $generaterRevenue;

    /**
     *
     * @ORM\Column(name="renevue_qtd", type="integer")
     */
    protected $renevueQtd;

    /**
     *
     * @ORM\Column(name="unit_value_forecast", type="decimal", precision=15, scale=2)
     */
    protected $unitValueForecast;

    /**
     *
     * @ORM\Column(name="total_value_forecast", type="decimal", precision=15, scale=2)
     */
    protected $totalValueForecast;

    /**
     *
     * @ORM\ManyToOne(targetEntity=\OpportunityWorkplan\Entities\WorkplanGoal::class, inversedBy="deliveries"))
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="goal_id", referencedColumnName="id", nullable=false, onDelete="CASCADE")
     * })
     */
    protected $goal;

    public function jsonSerialize(): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'description' => $this->description,
            'type' => $this->type,
            'segmentDelivery' => $this->segmentDelivery,
            'budgetAction' => $this->budgetAction,
            'expectedNumberPeople' => $this->expectedNumberPeople,
            'generaterRevenue' => $this->generaterRevenue,
            'renevueQtd' => $this->renevueQtd,
            'unitValueForecast' => $this->unitValueForecast,
            'totalValueForecast' => $this->totalValueForecast,
        ];
    }
}