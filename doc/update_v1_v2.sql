/*
Target Server Type    : SQLite
Target Server Version : 30706
File Encoding         : 65001

Date: 2022-02-28 20:09:32
*/


alter table t_user add COLUMN email TEXT NULL;
alter table t_user add COLUMN send INTEGER NOT NULL DEFAULT 0;

CREATE TABLE "t_smtp" (
"id"  INTEGER NOT NULL,
"server"  TEXT,
"ssl"  INTEGER,
"port"  INTEGER,
"user"  TEXT,
"password"  TEXT
);

INSERT INTO "main"."t_smtp" VALUES (1, '', 0, 25, '', '');

CREATE TABLE "t_warn" (
"id"  INTEGER NOT NULL,
"status"  INTEGER NOT NULL,
"send_time"  INTEGER NOT NULL,
"send_msg"  TEXT,
"admin_status"  INTEGER NOT NULL,
"admin_email"  TEXT,
"admin_msg"  TEXT
);

INSERT INTO "main"."t_warn" VALUES (1, 1, 1, '{username}:
       你的VPN用户在 {time} 到期，如果需要继续使用VPN，请向管理员申请续期。', 1, '', null);