ALTER TABLE
    `isu_condition`
ADD
    COLUMN `condition_level` VARCHAR(10);

UPDATE
    `isu_condition`
SET
    `condition_level` = CASE
        WHEN `condition` = 'is_dirty=false,is_overweight=false,is_broken=false' THEN 'info'
        WHEN `condition` = 'is_dirty=true,is_overweight=true,is_broken=true' THEN 'critical'
        ELSE 'warning'
    END;