<?php
namespace OpportunityWorkplan\Entities;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;

/**
 * 
 * @ORM\Table(name="registration_workplan")
 * @ORM\Entity
 * @ORM\entity(repositoryClass="MapasCulturais\Repository")
 */
class Workplan extends \MapasCulturais\Entity {


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
     * @ORM\Column(name="project_duration", type="integer")
     */
    protected $projectDuration;

    /**
     * @var string
     *
     * @ORM\Column(name="cultural_artistic_segment", type="string", length=50)
     */
    protected $culturalArtisticSegment;

    /**
     * @var \MapasCulturais\Entities\Registration
     *
     * @ORM\ManyToOne(targetEntity="MapasCulturais\Entities\Registration")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="registration_id", referencedColumnName="id", nullable=false, onDelete="CASCADE")
     * })
     */
    protected $registration;

    /**
    * @ORM\OneToMany(targetEntity=\OpportunityWorkplan\Entities\WorkplanGoal::class, mappedBy="workplan", cascade={"persist", "remove"}, orphanRemoval=true)
    */
    protected $goals;
    

    public function getGoals(): Collection
    {
        return $this->goals;
    }

    public function __construct() {
        $this->goals = new ArrayCollection();
        parent::__construct();
    }

    public function jsonSerialize(): array
    {
        $sortedGoals = $this->goals->toArray();

        usort($sortedGoals, function ($a, $b) {
            return $a->id <=> $b->id;
        });

        return [
            'id' => $this->id,
            'projectDuration' => $this->projectDuration,
            'culturalArtisticSegment' => $this->culturalArtisticSegment,
            'registrationId' => $this->registration->id,
            'registration' => $this->registration,
            'goals' => $sortedGoals,
        ];
    }


}