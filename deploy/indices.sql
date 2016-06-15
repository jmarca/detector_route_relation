-- Deploy detector_route_relations:indices to pg
-- requires: drr

BEGIN;

-- create some keys/indices to make the subsequent queries faster
ALTER TABLE tempseg.detector_route_relation ADD PRIMARY KEY (detector_id,relation_direction);
ALTER TABLE tempseg.detector_route_relation ADD CONSTRAINT tempseg_detector_route_relation_unique_wim_sequence_id UNIQUE (detector_sequence_id);
CREATE INDEX tempseg_detector_route_relations_line_idx ON tempseg.detector_route_relation USING GIST (line);
CREATE INDEX tempseg_detector_route_relation_detectorsnap_index ON tempseg.detector_route_relation USING gist( detectorsnap );


COMMIT;
