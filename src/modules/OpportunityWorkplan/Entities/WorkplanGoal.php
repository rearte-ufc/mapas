<?php
namespace OpportunityWorkplan\Entities;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;

/**
 * 
 * @ORM\Table(name="registration_workplan_goal")
 * @ORM\Entity
 * @ORM\entity(repositoryClass="MapasCulturais\Repository")
 */
class WorkplanGoal extends \MapasCulturais\Entity {


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
     * @ORM\Column(name="month_initial", type="string", length=50)
     */
    protected $monthInitial;

    /**
     * @var string
     *
     * @ORM\Column(name="month_end", type="string", length=50)
     */
    protected $monthEnd;

    /**
     * @var string
     *
     * @ORM\Column(name="title", type="string", length=255)
     */
    protected $title;

    /**
     * @var string
     *
     * @ORM\Column(name="description", type="text")
     */
    protected $description;

     /**
     * @var string
     *
     * @ORM\Column(name="cultural_making_stage", type="string", length=50)
     */
    protected $culturalMakingStage;

    /**
     *
     * @ORM\Column(name="amount", type="decimal", precision=15, scale=2)
     */
    protected $amount;

    /**
     *
     * @ORM\ManyToOne(targetEntity=\OpportunityWorkplan\Entities\Workplan::class, inversedBy="goals"))
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="workplan_id", referencedColumnName="id", nullable=false, onDelete="CASCADE")
     * })
     */
    protected $workplan;

    /**
    * @ORM\OneToMany(targetEntity=\OpportunityWorkplan\Entities\GoalDelivery::class, mappedBy="goal", cascade={"persist", "remove"}, orphanRemoval=true)
    */
    protected $deliveries;

    public function getDeliveries(): Collection
    {
        return $this->deliveries;
    }

    public function __construct() {
        $this->deliveries = new ArrayCollection();
        parent::__construct();
    }

    public function jsonSerialize(): array
    {
        $sortedDeliveries = $this->deliveries->toArray();

        usort($sortedDeliveries, function ($a, $b) {
            return $a->id <=> $b->id;
        });

        return [
            'id' => $this->id,
            'monthInitial' => $this->monthInitial,
            'monthEnd' => $this->monthEnd,
            'title' => $this->title,
            'description' => $this->description,
            'culturalMakingStage' => $this->culturalMakingStage,
            'amount' => $this->amount,
            'deliveries' => $sortedDeliveries
        ];
    }
}