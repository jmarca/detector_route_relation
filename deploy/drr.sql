-- Deploy detector_route_relations:drr to pg
-- requires: min_detector_distance:min_dist
-- requires: craigs_functions:craigs_functions

BEGIN;

CREATE SEQUENCE tempseg.detector_route_relation_detector_sequence_id_seq;

WITH detector_to_routeline AS (
    SELECT mld.detector_id,mld.relation_direction,mld.refnum,
        tempseg.multiline_locate_point_data( routeline, t.geom ) AS detectorsnap
    FROM
      tempseg.min_detector__distance mld
      JOIN tempseg.numbered_route_lines nrl
          ON (mld.refnum=nrl.refnum
          AND mld.relation_direction=nrl.direction)
      JOIN tempseg.tdetector t
          ON (mld.detector_id=t.detector_id
          AND mld.relation_direction=newtbmap.canonical_direction(t.direction))
      -- omit them since they're uninteresting anyway.
      WHERE routeline IS NOT NULL
      AND st_npoints(routeline)>1
),
snapped_detector AS (
    SELECT detector_id,refnum,relation_direction,
          (detectorsnap).point as detectorsnap,
          (detectorsnap).dist AS dist,
          (detectorsnap).line as line,
          (detectorsnap).numline as numline
  FROM
   -- Here, we join the DETECTOR to it's route line and compute the snap
   -- point
   detector_to_routeline q
   ORDER BY refnum,relation_direction,numline,dist
)
SELECT detector_id,refnum,relation_direction,detectorsnap, dist, line, numline,
    CAST(nextval('tempseg.detector_route_relation_detector_sequence_id_seq')
         AS int) AS detector_sequence_id
INTO tempseg.detector_route_relation
FROM snapped_detector qq
;


ALTER SEQUENCE tempseg.detector_route_relation_detector_sequence_id_seq OWNED BY tempseg.detector_route_relation.detector_sequence_id;


COMMIT;
