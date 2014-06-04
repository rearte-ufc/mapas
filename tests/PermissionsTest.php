<?php
require_once __DIR__.'/bootstrap.php';
/**
 * Description of PermissionsTest
 *
 * @author rafael
 */
class PermissionsTest extends MapasCulturais_TestCase{
    protected $entities = [
        'Agent' => 'agents',
        'Space' => 'spaces',
        'Event' => 'events',
        'Project' => 'projects'
    ];

    function getNewEntity($class, $user = null){
        if(!is_null($user)){
            $_user = $this->app->user->is('guest') ? null : $this->app->user;
            $this->user = $user;
        }
            
        $app = MapasCulturais\App::i();
        $classname = 'MapasCulturais\Entities\\' . $class;

        $type = array_shift($app->getRegisteredEntityTypes($classname));

        $entity = new $classname;
        $entity->name = "Test $class "  . uniqid();
        $entity->type = $type;
        $entity->shortDescription = 'A litle short description';
        
        if(!is_null($user)){
            $this->user = $_user;
        }
        return $entity;
    }

    function getRandomEntity($_class, $where = null){
        $app = MapasCulturais\App::i();
        $classname = 'MapasCulturais\Entities\\' . $_class;

        $where = $where ? "AND $where" : '';
        if($_class === 'User')
            return $this->app->em->createQuery("SELECT e FROM $classname e WHERE e.status > 0 $where")->setMaxResults(1)->getOneOrNullResult();
        else if($_class === 'Agent')
            return $this->app->em->createQuery("SELECT e FROM $classname e JOIN e.user u WHERE e.status > 0 $where")->setMaxResults(1)->getOneOrNullResult();
        else
            return $this->app->em->createQuery("SELECT e FROM $classname e JOIN e.owner a JOIN a.user u WHERE e.status > 0 $where")->setMaxResults(1)->getOneOrNullResult();

    }

    function assertPermissionDenied($callable, $msg = ''){
        $exception = null;
        try{
            $callable = \Closure::bind($callable, $this);
            $callable();
        } catch (MapasCulturais\Exceptions\PermissionDenied $ex) {
            $exception = $ex;
        }

        $this->assertInstanceOf('MapasCulturais\Exceptions\PermissionDenied', $exception, $msg);
    }


    function assertPermissionGranted($callable, $msg = ''){
        $exception = null;
        try{
            $callable = \Closure::bind($callable, $this);
			$callable();
        } catch (MapasCulturais\Exceptions\PermissionDenied $ex) {
            $exception = $ex;
            $msg .= '(message: "' . $ex->getMessage() . '")';
        }

        $this->assertEmpty($exception, $msg);
    }

    function testCanUserCreate(){
        $app = MapasCulturais\App::i();

        /*
         * Guest users cant create entities.
         */
        $this->user = null;

        foreach($this->entities as $class => $plural){
            if($class === 'Agent')
                continue;

            $this->assertPermissionDenied(function() use ($class){
                $entity = $this->getNewEntity($class);
                $entity->save(true);
            }, "Asserting that the guest user CANNOT create $plural.");
        }

        /*
         * Super Admins can create entities
         */
        $this->user = 'superAdmin';


        foreach($this->entities as $class => $plural){
            $this->assertPermissionGranted(function() use ($class){
                $entity = $this->getNewEntity($class);
                $entity->save(true);
            }, "Asserting that a super admin user CAN create $plural.");
        }


        /*
         * Normal users cannot create entities to another users
         */
        $this->user = 'normal';

        $another_user = $this->getRandomEntity('User', 'e.id != ' . $app->user->id);

        foreach($this->entities as $class => $plural){
            $this->assertPermissionDenied(function() use ($class, $another_user){
                $entity = $this->getNewEntity($class);

                if($class === 'Agent'){
                    $entity->user = $another_user;
                }else
                    $entity->ownerId = $another_user->profile->id;

                $entity->save(true);
            }, "Asserting that a normal user CANNOT create $plural to another user.");
        }

        /*
         * Super Admins can create entities to another users
         */
        $this->user = 'superAdmin';

        foreach($this->entities as $class => $plural){
            $this->assertPermissionGranted(function() use ($class, $another_user){
                $entity = $this->getNewEntity($class);

                if($class === 'Agent')
                    $entity->user = $another_user;
                else
                    $entity->ownerId = $another_user->profile->id;

                $entity->save(true);
            }, "Asserting that a super admin user CAN create $plural to another user.");
        }
    }



    function testCanUserModify(){
        /*
         * Asserting thar guest users cannot modify entities
         */

        $this->user = null;

        foreach($this->entities as $class => $plural){
            $this->assertPermissionDenied(function() use ($class){
                $entity = $this->getRandomEntity($class);
                $entity->shortDescription = "modificado " . uniqid();
                $entity->save(true);
            }, "Asserting that guest user CANNOT modify $plural");
        }


        foreach(['normal', 'staff'] as $role){
            $this->user = $role;
            /*
             * Asserting thar normal and staff users cannot modify entities of other user
             */
            foreach($this->entities as $class => $plural){
                $this->assertPermissionDenied(function() use ($class){
                    $entity = $this->getRandomEntity($class, "u.id != " . $this->app->user->id);
                    $entity->shortDescription = "modificado " . uniqid();
                    $entity->save(true);
                }, "Asserting that $role user CANNOT modify $plural of other user");
            }


            /*
             * Asserting thar normal and staff users can modify their own entities
             */
            foreach($this->entities as $class => $plural){
                $this->assertPermissionGranted(function() use ($class){
                    $entity = $this->getRandomEntity($class, "u.id = " . $this->app->user->id);
                    $entity->shortDescription = "modificado " . uniqid();
                    $entity->save(true);
                }, "Asserting that $role user CAN modify their own $plural");
            }
        }

        foreach(['admin', 'superAdmin'] as $role){
            $this->user = $role;
            /*
             * Asserting thar admin and super admin users can modify entities of other user
             */
            foreach($this->entities as $class => $plural){
                $this->assertPermissionGranted(function() use ($class){
                    $entity = $this->getRandomEntity($class, "u.id != " . $this->app->user->id);
                    $entity->shortDescription = "modificado " . uniqid();
                    $entity->save(true);
                }, "Asserting that $role user CANNOT modify $plural of other user");
            }
        }


    }

    function testCanUserRemove(){ }

    function testCanUserVerifyEntity(){
        $app = $this->app;

        $this->user = null;

        /*
         * Asserting that guest users cannot verify entities
         */

        foreach($this->entities as $class => $plural){
            $this->assertPermissionDenied(function() use ($class){
                $entity = $this->getRandomEntity('Agent', 'e.isVerified = false');
                $entity->verify();
                $entity->save(true);
            }, "Asserting that a guest user CANNOT verify $plural.");
        }


        /*
         * Asserting that normal users cannot verify entities
         */

        $this->user = 'normal';

        foreach($this->entities as $class => $plural){
            $this->assertPermissionDenied(function() use ($class, $app){
                $entity = $this->getNewEntity($class);
                $entity->save(true);

                $entity->verify();
                $entity->save(true);
            }, "Asserting that a normal user CANNOT verify their own $plural.");
        }

        foreach($this->entities as $class => $plural){
            $this->assertPermissionDenied(function() use ($class, $app){
                $entity = $this->getRandomEntity('Agent', 'e.isVerified = false AND e.userId != ' . $app->user->id);
                $entity->verify();
                $entity->save(true);
            }, "Asserting that a normal user CANNOT verify $plural of other user.");
        }


        /*
         * Asserting that staff users can verify entities
         */

        $this->user = 'staff';

        foreach($this->entities as $class => $plural){
            $this->assertPermissionDenied(function() use ($class, $app){
                $entity = $this->getRandomEntity($class, 'e.isVerified = false AND u.id != ' . $app->user->id);
                $entity->verify();
                $entity->save(true);
            }, "Asserting that a staff user CANNOT verify $plural of other user.");
        }

        foreach($this->entities as $class => $plural){
            $this->assertPermissionGranted(function() use ($class, $app){
                $entity = $this->getNewEntity($class);
                $entity->save(true);

                $entity->verify();
                $entity->save(true);
            }, "Asserting that a staff user CAN verify their own $plural.");
        }


        /*
         * Asserting that admin users can verify entities
         */

        $this->user = 'admin';

        foreach($this->entities as $class => $plural){
            $this->assertPermissionGranted(function() use ($class, $app){
                $entity = $this->getRandomEntity($class, 'e.isVerified = false AND u.id != ' . $app->user->id);
                $entity->verify();
                $entity->save(true);
            }, "Asserting that a admin user CAN verify $plural of other user.");
        }

        foreach($this->entities as $class => $plural){
            $this->assertPermissionGranted(function() use ($class, $app){
                $entity = $this->getNewEntity($class);
                $entity->save(true);

                $entity->verify();
                $entity->save(true);
            }, "Asserting that a staff user CAN verify their own $plural.");
        }
    }

    function testCanUserViewPrivateData(){ }

    function testAgentRelationsPermissions(){
        // create agent relation without control

        // create agent relation withcontrol

        // remove agent relation without control

        // remove agent relation with control
        
        // assert that related agent with control cannot change the entity owner
        
        $GROUP = 'group 1';
        
        $user1 = function (){ return $this->getUser('normal', 0); };
        $user2 = function (){ return $this->getUser('normal', 1); };
        $user3 = function (){ return $this->getUser('staff', 0); };
        
        /*
         * Asserting that owner user and a related agent with control can modify an entity
         */
        
        foreach($this->entities as $class => $plural){
            $entities = $class == 'Agent' ? $user1()->$plural : $user1()->profile->$plural;
            
            $entity = $entities[0];
            
            $this->assertTrue($entity->canUser('modify', $user1()), 'Asserting that user 1 CAN modify the ' . $class . ' before the relation is created.');
            $this->assertFalse($entity->canUser('modify', $user2()), 'Asserting that user 2 CANNOT modify the ' . $class . ' before the relation is created.');
            $this->assertFalse($entity->canUser('modify', $user3()), 'Asserting that user 3 CANNOT modify the ' . $class . ' before the relation is created.');


            // login with user1
            $this->user = $user1();

            // create the realation with control
            $entity->createAgentRelation($user2()->profile, $GROUP, true, true);

            // logout
            $this->user = null;

            $this->assertTrue($entity->canUser('modify', $user1()), 'Asserting that user 1 CAN modify the ' . $class . ' after the relation is created.');
            $this->assertTrue($entity->canUser('modify', $user2()), 'Asserting that user 2 CAN modify the ' . $class . ' after the relation is created.');
            $this->assertFalse($entity->canUser('modify', $user3()), 'Asserting that user 3 CANNOT modify the ' . $class . ' after the relation is created.');
            
            $this->resetTransactions();
        }
        
        
        
        /*
         * Asserting that only the owner user can modify the agentId (the owner) of the entity
         */
        
        $new_agent1 = $this->getNewEntity('Agent', $user1());
        $new_agent2 = $this->getNewEntity('Agent', $user2());
        $new_agent3 = $this->getNewEntity('Agent', $user3());
        
        $new_agent1->save(true);
        $new_agent2->save(true);
        $new_agent3->save(true);
        
        foreach($this->entities as $class => $plural){
            if($class == 'Agent')
                continue;
            
            $entities = $user1()->$plural;
            $entity = $entities[0];
            
            
            $this->user = 'admin';
            $this->assertPermissionGranted(function() use($entity){
                $old_owner = $entity->owner;
                $entity->owner = $this->app->user->profile;
                $entity->save(true);
                
                $entity->owner = $old_owner;
                $entity->save(true);
                
            }, 'Asserting that the an admin user CAN modify the ' . $class . ' owner');
            
            $this->user = $user1();
            $this->assertPermissionGranted(function() use($entity, $new_agent1){
                $entity->owner = $new_agent1;
                $entity->save(true);
            }, 'Asserting that the user 1 CAN modify the ' . $class . ' owner before the relation is created.');
            
            $this->user = $user2();
            $this->assertPermissionDenied(function() use($entity, $new_agent2){
                $entity->owner = $new_agent2;
                $entity->save(true);
            }, 'Asserting that the user 2 CANNOT modify the ' . $class . ' owner before the relation is created.');
            
            $this->user = $user3();
            $this->assertPermissionDenied(function() use($entity, $new_agent3){
                $entity->owner = $new_agent3;
                $entity->save(true);
            }, 'Asserting that the user 3 CANNOT modify the ' . $class . ' owner before the relation is created.');
            
            
            // login with user1
            $this->user = $user1();

            // create the realation with control
            $entity->createAgentRelation($user2()->profile, $GROUP, true, true);

            $this->assertPermissionGranted(function() use($entity, $new_agent1){
                $entity->owner = $new_agent1;
                $entity->save(true);
            }, 'Asserting that the user 1 CAN modify the ' . $class . ' owner before the relation is created.');
            
            $this->user = $user2();
            $this->assertPermissionDenied(function() use($entity, $new_agent2){
                $entity->owner = $new_agent2;
                $entity->save(true);
            }, 'Asserting that the user 2, now with control, CANNOT modify the ' . $class . ' owner AFTER the relation is created.');
            
            $this->user = $user3();
            $this->assertPermissionDenied(function() use($entity, $new_agent3){
                $entity->owner = $new_agent3;
                $entity->save(true);
            }, 'Asserting that the user 3 CANNOT modify the ' . $class . ' owner after the relation is created.');
        }
        
        $this->resetTransactions();
        
        
        /*
         * Asserting that only the owner user can remove an entity
         */
        
        foreach($this->entities as $class => $plural){
            $this->user = $user1();
        
            if($class == 'Agent'){
                $entity = $this->getNewEntity($class);;
                $entity->save(true);
            }else{
                $entities = $user1()->$plural;
                $entity = $entities[0];
            }
            
            
            $this->assertTrue($entity->canUser('remove', $user1()), 'Asserting that user 1 CAN remove the ' . $class . ' before the relation is created.');
            $this->assertFalse($entity->canUser('remove', $user2()), 'Asserting that user 2 CANNOT remove the ' . $class . ' before the relation is created.');
            $this->assertFalse($entity->canUser('remove', $user3()), 'Asserting that user 3 CANNOT remove the ' . $class . ' before the relation is created.');

            // create the realation with control
            $entity->createAgentRelation($user2()->profile, $GROUP, true, true);

            // logout
            $this->user = null;

            $this->assertTrue($entity->canUser('remove', $user1()), 'Asserting that user 1 CAN remove the ' . $class . ' after the relation is created.');
            $this->assertFalse($entity->canUser('remove', $user2()), 'Asserting that user 2 CANNOT remove the ' . $class . ' after the relation is created.');
            $this->assertFalse($entity->canUser('remove', $user3()), 'Asserting that user 3 CANNOT remove the ' . $class . ' after the relation is created.');
        }
        
        $this->resetTransactions();
        
        /*
         *  Asserting that user with control can create spaces, projects and events owned by the controlled agent.
         */
        foreach($this->entities as $class => $plural){
            if($class == 'Agent')
                continue;
            
            
            $this->assertPermissionGranted(function() use($user1, $class){
                $this->user = $user1();
                $entity = $this->getNewEntity($class, $user1());
                $entity->save(true);
            }, "Asserting that user 1 CAN create $plural to his own agent before the relation is created");
            
            $this->assertPermissionDenied(function() use($user1, $user2, $class){
                $this->user = $user2();
                $entity = $this->getNewEntity($class);
                $entity->owner = $user1()->profile;
                $entity->save(true);
            }, "Asserting that user 2 CANNOT create $plural owned by user 1 agent before the relation is created");
            
            $this->assertPermissionDenied(function() use($user1, $user3, $class){
                $this->user = $user3();
                $entity = $this->getNewEntity($class);
                $entity->owner = $user1()->profile;
                $entity->save(true);
            }, "Asserting that user 3 CANNOT create $plural owned by user 1 agent before the relation is created");
            
            
            $this->user = $user1();
            $agent = $user1()->profile;
            $agent->createAgentRelation($user2()->profile, $GROUP, true, true);
            
            
            $this->assertPermissionGranted(function() use($user1, $class){
                $this->user = $user1();
                $entity = $this->getNewEntity($class, $user1());
                $entity->save(true);
            }, "Asserting that user 1 CAN create $plural to his own agent before the relation is created");
            
            $this->assertPermissionGranted(function() use($user1, $user2, $class){
                $this->user = $user2();
                $entity = $this->getNewEntity($class);
                $entity->owner = $user1()->profile;
                $entity->save(true);
            }, "Asserting that user 2 CAN create $plural owned by user 1 agent after the relation is created");
            
            $this->assertPermissionDenied(function() use($user1, $user3, $class){
                $this->user = $user3();
                $entity = $this->getNewEntity($class);
                $entity->owner = $user1()->profile;
                $entity->save(true);
            }, "Asserting that user 3 CANNOT create $plural owned by user 1 agent after the relation is created");
            
            $this->resetTransactions();
        }
        
        /*
         *  Asserting that user with control can create spaces, projects and events owned by the controlled agent.
         */
        foreach($this->entities as $class => $plural){
            if($class == 'Agent')
                continue;
            
            
            $this->assertPermissionGranted(function() use($user1, $plural){
                $this->user = $user1();
                
                $entities = $user1()->$plural;
                $entity = $entities[0];
                $entity->delete(true);
                
            }, "Asserting that user 1 CAN remove $plural to his own agent before the relation is created");
            
            $this->resetTransactions();
            
            $this->assertPermissionDenied(function() use($user1, $user2, $plural){
                $this->user = $user2();
                
                $entities = $user1()->$plural;
                $entity = $entities[0];
                $entity->delete(true);
                
            }, "Asserting that user 2 CANNOT remove $plural owned by user 1 agent before the relation is created");
            
            $this->resetTransactions();
            
            $this->assertPermissionDenied(function() use($user1, $user3, $plural){
                $this->user = $user3();
                
                $entities = $user1()->$plural;
                $entity = $entities[0];
                $entity->delete(true);
                
            }, "Asserting that user 3 CANNOT remove $plural owned by user 1 agent before the relation is created");
            
            $this->resetTransactions();
            $this->user = $user1();
            $user1()->profile->createAgentRelation($user2()->profile, $GROUP, true, true);
            
            $this->assertPermissionGranted(function() use($user1, $plural){
                $this->user = $user1();
                
                $entities = $user1()->$plural;
                $entity = $entities[0];
                $entity->delete(true);
                
            }, "Asserting that user 1 CAN remove $plural owned by his own agent before the relation is created");
            
            $this->resetTransactions();
            $this->user = $user1();
            $user1()->profile->createAgentRelation($user2()->profile, $GROUP, true, true);
            
            $this->assertPermissionGranted(function() use($user1, $user2, $user3, $plural){
                $this->user = $user2();
                
                $entities = $user1()->profile->$plural;
                $entity = $entities[0];
                $entity->delete(true);
                
            }, "Asserting that user 2 CAN remove $plural owned by user 1 agent after the relation is created");
            
            $this->resetTransactions();
            $this->user = $user1();
            $user1()->profile->createAgentRelation($user2()->profile, $GROUP, true, true);
            
            $this->assertPermissionDenied(function() use($user1, $user3, $plural){
                $this->user = $user3();
                
                $entities = $user1()->profile->$plural;
                $entity = $entities[0];
                $entity->delete(true);
                
            }, "Asserting that user 3 CANNOT remove $plural owned by user 1 agent after the relation is created");
            
            $this->resetTransactions();
        }
        
    }

    function testProjectRegistrationPermissions(){
        // approve registration

        // reject registration
    }

    function testFilesPermissions(){

    }

    function testMetalistPermissions(){

    }

    function testCanUserAddRemoveRole(){
        $roles = ['staff', 'admin', 'superAdmin'];

        /*
         * Guest user cannot add or remove roles
         */
        $this->user = null;

        foreach($roles as $role){
            $this->assertPermissionDenied(function() use($role){
                $user = $this->getUser('normal', 1);
                $user->addRole($role);
            }, "Asserting that guest user CANNOT add the role $role to a user");
        }

        foreach($roles as $role){
            $this->assertPermissionDenied(function() use($role){
                $user = $this->getUser($role, 1);
                $user->removeRole($role);
            }, "Asserting that guest user CANNOT remove the role $role of a user");
        }


        /*
         * Normal user cannot add or remove roles
         */
        $this->user = 'normal';

        foreach($roles as $role){
            $this->assertPermissionDenied(function() use($role){
                $user = $this->getUser('normal', 1);
                $user->addRole($role);
            }, "Asserting that normal user CANNOT add the role $role to a user");
        }

        foreach($roles as $role){
            $this->assertPermissionDenied(function() use($role){
                $user = $this->getUser($role, 1);
                $user->removeRole($role);
            }, "Asserting that normal user CANNOT remove the role $role of a user");
        }


        /*
         * Admin user can add and remove role staff
         */
        $this->user = 'admin';

        foreach($roles as $role){
            $this->resetTransactions();

            switch ($role) {
                case 'staff':
                    $assertion = 'assertPermissionGranted';
                    $can = 'CAN';
                break;

                default:
                    $assertion = 'assertPermissionDenied';
                    $can = 'CANNOT';
                break;
            }

            $this->$assertion(function() use($role){
                $user = $this->getUser('normal', 1);
                $user->addRole($role);
            }, "Asserting that admin user $can add the role $role to a user");
        }

        foreach($roles as $role){
            $this->resetTransactions();

            switch ($role) {
                case 'staff':
                    $assertion = 'assertPermissionGranted';
                    $can = 'CAN';
                break;

                default:
                    $assertion = 'assertPermissionDenied';
                    $can = 'CANNOT';
                break;
            }

            $this->$assertion(function() use($role){
                $user = $this->getUser($role, 1);
                $user->removeRole($role);
            }, "Asserting that admin user $can remove the role $role of a user");
        }

        /*
         * Admin user can add and remove role staff
         */
        $this->user = 'superAdmin';

        foreach($roles as $role){
            $this->resetTransactions();

            $this->assertPermissionGranted(function() use($role){
                $user = $this->getUser('normal', 1);
                $user->addRole($role);
            }, "Asserting that super admin user CAN add the role $role to a user");
        }

        foreach($roles as $role){
            $this->resetTransactions();

            $this->assertPermissionGranted(function() use($role){
                $user = $this->getUser($role, 1);
                $user->removeRole($role);
            }, "Asserting that super admin user CAN remove the role $role of a user");
        }
    }
}