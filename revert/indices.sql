-- Revert detector_route_relations:indices from pg

BEGIN;

-- create some keys/indices to make the subsequent queries faster
ALTER TABLE tempseg.detector_route_relation DROP PRIMARY KEY (detector_id,relation_direction);
ALTER TABLE tempseg.detector_route_relation DROP CONSTRAINT tempseg_detector_route_relation_unique_wim_sequence_id;

DROP INDEX tempseg_detector_route_relations_line_idx;
DROP INDEX tempseg_detector_route_relation_detectorsnap_index;


COMMIT;
