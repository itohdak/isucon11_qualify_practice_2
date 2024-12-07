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

DROP TABLE IF EXISTS `isu_latest_condition`;

CREATE TABLE `isu_latest_condition` (
    `jia_isu_uuid` CHAR(36) NOT NULL UNIQUE,
    `timestamp` DATETIME NOT NULL,
    `is_sitting` TINYINT(1) NOT NULL,
    `condition` VARCHAR(255) NOT NULL,
    `message` VARCHAR(255) NOT NULL,
    `created_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    `condition_level` VARCHAR(10) NOT NULL,
    PRIMARY KEY(`jia_isu_uuid`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

CREATE INDEX isu_latest_condition_jia_isu_uuid_timestamp_desc ON `isu_condition`(jia_isu_uuid, timestamp DESC);

INSERT INTO
    `isu_latest_condition` (
        `jia_isu_uuid`,
        `timestamp`,
        `is_sitting`,
        `condition`,
        `message`,
        `created_at`,
        `condition_level`
    )
SELECT
    c1.`jia_isu_uuid`,
    c1.`timestamp`,
    c1.`is_sitting`,
    c1.`condition`,
    c1.`message`,
    c1.`created_at`,
    c1.`condition_level`
FROM
    `isu_condition` c1
    JOIN (
        SELECT
            c2.`jia_isu_uuid`,
            max(c2.`timestamp`) AS `timestamp`
        FROM
            `isu_condition` c2
        GROUP BY
            c2.`jia_isu_uuid`
    ) AS c3 ON c1.`jia_isu_uuid` = c3.`jia_isu_uuid`
    AND c1.`timestamp` = c3.`timestamp`;