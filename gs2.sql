CREATE TABLE ACTIVITY_LOG (
  log_id NUMBER PRIMARY KEY,
  user_id NUMBER,
  action_type VARCHAR2(100),
  details_json CLOB,
  created_at TIMESTAMP
);

CREATE SEQUENCE ACTIVITY_LOG_SEQ
  START WITH 1
  INCREMENT BY 1
  NOCACHE;
  
SELECT table_name 
FROM user_tables 
WHERE table_name = 'ACTIVITY_LOG';

CREATE TABLE ENROLLMENTS (
  enroll_id NUMBER PRIMARY KEY,
  user_id NUMBER,
  course_id NUMBER,
  progress NUMBER(5,2), -- porcentagem de progresso
  status VARCHAR2(20),  -- valores como 'ACTIVE', 'COMPLETED', etc.
  started_at DATE,
  finished_at DATE
);

CREATE TABLE LEARNING_METRICS (
  metric_id NUMBER PRIMARY KEY,
  enroll_id NUMBER,
  metric_type VARCHAR2(50),
  value NUMBER(10,2),
  recorded_at TIMESTAMP,
  CONSTRAINT fk_enroll FOREIGN KEY (enroll_id) REFERENCES ENROLLMENTS(enroll_id)
);

CREATE SEQUENCE LEARNING_METRICS_SEQ
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
  
  CREATE TABLE PROFILES (
  profile_id NUMBER PRIMARY KEY,
  user_id NUMBER NOT NULL,
  bio VARCHAR2(500),
  experience_years NUMBER,
  created_at TIMESTAMP
);

CREATE TABLE PROFILE_SKILLS (
  skill_id NUMBER PRIMARY KEY,
  profile_id NUMBER NOT NULL,
  skill_name VARCHAR2(100),
  proficiency_level NUMBER(2), -- 1 a 10, por exemplo
  CONSTRAINT fk_profile_skill FOREIGN KEY (profile_id)
    REFERENCES PROFILES(profile_id)
);

CREATE SEQUENCE PROFILES_SEQ
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

CREATE SEQUENCE PROFILE_SKILLS_SEQ
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

CREATE OR REPLACE PROCEDURE register_activity(
  p_user_id IN NUMBER,
  p_action_type IN VARCHAR2,
  p_details IN CLOB
) AS
BEGIN
  INSERT INTO ACTIVITY_LOG(log_id, user_id, action_type, details_json, created_at)
  VALUES (ACTIVITY_LOG_SEQ.NEXTVAL, p_user_id, p_action_type, p_details, SYSTIMESTAMP);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END register_activity;
/

CREATE OR REPLACE PROCEDURE recompute_learning_metrics IS
  CURSOR c_enroll IS
    SELECT enroll_id, progress FROM ENROLLMENTS WHERE status = 'ACTIVE';
BEGIN
  FOR r IN c_enroll LOOP
    -- exemplo simples: se progress mudou, insere um registro em LEARNING_METRICS
    INSERT INTO LEARNING_METRICS(metric_id, enroll_id, metric_type, value, recorded_at)
    VALUES (LEARNING_METRICS_SEQ.NEXTVAL, r.enroll_id, 'progress_snapshot', r.progress, SYSTIMESTAMP);
  END LOOP;
  COMMIT;
END recompute_learning_metrics;
/

CREATE OR REPLACE FUNCTION compute_candidate_score(p_user_id IN NUMBER) RETURN NUMBER IS
  v_score NUMBER := 0;
  v_skill_count NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO v_skill_count FROM PROFILE_SKILLS ps WHERE ps.profile_id = (SELECT profile_id FROM PROFILES p WHERE p.user_id = p_user_id);
  v_score := v_skill_count * 10; -- regra simples
  RETURN v_score;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END compute_candidate_score;
/

BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'JOB_RECOMPUTE_LEARNING_METRICS',
    job_type => 'STORED_PROCEDURE',
    job_action => 'recompute_learning_metrics',
    start_date => SYSTIMESTAMP,
    repeat_interval => 'FREQ=DAILY;BYHOUR=2', -- todo dia às 02:00
    enabled => TRUE
  );
END;
/

GRANT CREATE JOB TO seu_usuario;

GRANT MANAGE SCHEDULER TO seu_usuario;
GRANT EXECUTE ON DBMS_SCHEDULER TO seu_usuario;
CREATE OR REPLACE PROCEDURE recompute_learning_metrics AS ...

SHOW ERRORS PROCEDURE recompute_learning_metrics;

SELECT line, position, text
FROM user_errors
WHERE name = 'RECOMPUTE_LEARNING_METRICS'
ORDER BY line;

SELECT *
FROM user_errors
WHERE name = 'RECOMPUTE_LEARNING_METRICS';

GRANT CREATE ANY JOB TO seu_usuario;

  BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'JOB_RECOMPUTE_LEARNING_METRICS',
    job_type => 'STORED_PROCEDURE',
    job_action => 'recompute_learning_metrics',
    start_date => SYSTIMESTAMP,
    repeat_interval => 'FREQ=DAILY;BYHOUR=2', -- todo dia às 02:00
    enabled => TRUE
  );
END;
/