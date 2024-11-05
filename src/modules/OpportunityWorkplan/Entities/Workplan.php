<?php
namespace OpportunityWorkplan\Entities;

use Doctrine\ORM\Mapping as ORM;

/**
 * 
 * @ORM\Table(name="registration_workplan")
 * @ORM\Entity
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
     * @var WorkplanGoals[]
     *
     * @ORM\OneToMany(targetEntity=WorkplanGoals::class, mappedBy="workplan", cascade={"persist", "remove"})
     */
    protected $goals;


}