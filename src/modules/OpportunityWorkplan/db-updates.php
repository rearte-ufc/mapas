<?php

namespace MapasCulturais;

$app = App::i();
$em = $app->em;
$conn = $em->getConnection();

return [
    'create table workplan' => function () {
        __exec("CREATE TABLE registration_workplan (
          id SERIAL PRIMARY KEY,
          registration_id INTEGER,
          project_duration INTEGER,
          cultural_artistic_segment VARCHAR(50)
      )");

        __exec("ALTER TABLE registration_workplan ADD FOREIGN KEY (registration_id) REFERENCES registration(id)");
    },
    'create table workplan goals' => function () {
        __exec("CREATE TABLE registration_workplan_goal (
          id SERIAL PRIMARY KEY,
          workplan_id INTEGER,
          month_initial VARCHAR(50),
          month_end VARCHAR(50),
          title VARCHAR(255),
          description TEXT,
          cultural_making_stage VARCHAR(50),
          amount numeric(15, 2)
      )");

        __exec("ALTER TABLE registration_workplan_goal ADD FOREIGN KEY (workplan_id) REFERENCES registration_workplan(id)");
    },

    'create table deliveries' => function () {
      __exec("CREATE TABLE registration_workplan_goal_delivery (
        id SERIAL PRIMARY KEY,
        goal_id INTEGER,
        name VARCHAR(255),
        description VARCHAR(255),
        type VARCHAR(50),
        segment_delivery VARCHAR(50),
        budget_action VARCHAR(50),
        expected_number_people INTEGER,
        generate_revenue BOOLEAN,
        renevue_qtd INTEGER,
        unit_value_forecast numeric(15, 2),
        total_value_forecast numeric(15, 2)
    )");

      __exec("ALTER TABLE registration_workplan_goal_delivery ADD FOREIGN KEY (goal_id) REFERENCES registration_workplan_goal(id)");
  },
];
