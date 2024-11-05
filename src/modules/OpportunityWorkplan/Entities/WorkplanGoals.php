<?php
namespace OpportunityWorkplan\Entities;

use Doctrine\ORM\Mapping as ORM;

/**
 * 
 * @ORM\Table(name="registration_workplan_goals")
 * @ORM\Entity
 */
class WorkplanGoals extends \MapasCulturais\Entity {


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
     * @var string
     *
     * @ORM\Column(name="amount", type="decimal", precision=15, scale=2)
     */
    protected $amount;

    /**
     *
     * @ORM\ManyToOne(targetEntity=OpportunityWorkplan\Entities\Workplan::class, inversedBy="goals"))
     * @ORM\JoinColumn(nullable=true)
     */
    protected $workplan;
}