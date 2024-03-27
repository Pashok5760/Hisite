BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"nickname"	VARCHAR(100),
	"password_hash"	VARCHAR(100),
	"dob"	DATE,
	"description"	TEXT,
	"age"	INTEGER,
	"photo"	VARCHAR(1000),
	"rating"	INTEGER,
	"city"	VARCHAR(100),
	UNIQUE("nickname"),
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "likes" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER,
	"liked_user_id"	INTEGER,
	"message"	TEXT,
	FOREIGN KEY("user_id") REFERENCES "user"("id"),
	FOREIGN KEY("liked_user_id") REFERENCES "user"("id"),
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "messages" (
	"id"	INTEGER NOT NULL,
	"sender_id"	INTEGER,
	"recipient_id"	INTEGER,
	"body"	TEXT,
	"timestamp"	DATETIME,
	FOREIGN KEY("sender_id") REFERENCES "user"("id"),
	FOREIGN KEY("recipient_id") REFERENCES "user"("id"),
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "alembic_version" (
	"version_num"	VARCHAR(32) NOT NULL,
	CONSTRAINT "alembic_version_pkc" PRIMARY KEY("version_num")
);
INSERT INTO "user" VALUES (1,'Administrator','Administrator','pbkdf2:sha256:260000$bqcVIYBgLozxPup0$168fc91e726349a55e8070bfe80f2fec389fbaa759cdf0dd00a96af5bfb34a41','2006-06-24','Программист',NULL,'../static/img/1.jpg',1,'Уссурийск');
INSERT INTO "user" VALUES (2,'Стёпочка','Стёпочка' , 'pbkdf2:sha256:260000$Zceo3QRVhr9LKnWn$09c1a09c787289232b5ab395e5e9e906bcc1916569a8bb89e893448db4895fbb','2010-10-15','Дружелюбный',NULL,'../static/img/2.jpg',3,'Уссурийск');
INSERT INTO "user" VALUES (3,'Роктум','Роктум','pbkdf2:sha256:260000$bpnZW1J6gMqejI1O$69cc7495e7a0d38b006cc2d781aab8060a943050cc4fd88b0252f12ee83ead46','2006-05-07','Живой вроде',NULL,'../static/img/3.jpg',3,'Уссурийск');
INSERT INTO "user" VALUES (4,'Паша','Паша','pbkdf2:sha256:260000$rwez9C2lDtSrrkr0$72670f862286eb379a1ff16f736c830b77c4f409698ee02a63d67b16f3d75945','2006-06-24','Классный пацан',NULL,'../static/img/4.jpg',2,'Уссурийск');
INSERT INTO "user" VALUES (5,'Андрей1984', 'Андрей1984', 'pbkdf2:sha256:260000$4a4MVG3cCwSVOtdB$674bde96595133b06f78dcb02f53f03d0ca65e675a7489c0c3ad64245fa38ed4','1989-03-09','Всем привет',NULL,'../static/img/5.jpg',4,'Уссурийск');
INSERT INTO "user" VALUES (6,'Ульяна', 'Ульяна' , 'pbkdf2:sha256:260000$9ZAXCbmgsqEG0vao$7fa2a8ed46d5094794bce420d9bbc10115d2d10562fc5afca6b211fb0c0fc784','1985-04-06','Ты лучший😘, помни об этом всегда!!! 😉',NULL,'../static/img/6.jpg',2,'Уссурийск');

INSERT INTO "likes" VALUES (1,4,3,'Здарова Данил');
INSERT INTO "likes" VALUES (2,3,4,'1');
INSERT INTO "likes" VALUES (3,2,3,'Привет, я Стёпочка, го др, Данил');
INSERT INTO "likes" VALUES (5,4,2,'1');
INSERT INTO "likes" VALUES (6,1,5,'');
INSERT INTO "likes" VALUES (7,5,1,'1');
INSERT INTO "likes" VALUES (8,4,5,'');
INSERT INTO "likes" VALUES (9,5,4,'1');
INSERT INTO "likes" VALUES (10,6,5,'');
INSERT INTO "likes" VALUES (11,6,2,'');
INSERT INTO "likes" VALUES (12,6,4,'');
INSERT INTO "likes" VALUES (13,3,5,'Саламуля');
INSERT INTO "likes" VALUES (14,4,6,'1');
INSERT INTO "likes" VALUES (15,12,1,'');
INSERT INTO "likes" VALUES (16,5,3,'Привет
');
INSERT INTO "likes" VALUES (17,5,6,'');
INSERT INTO "likes" VALUES (18,5,2,'');
INSERT INTO "likes" VALUES (19,2,6,'Мамуля лучшая😎😎');
INSERT INTO "messages" VALUES (1,1,3,'Для тебя новая заявка от юзера! Вот сообщение для тебя: Здарова Данил.                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Роктум <img src="../static/img/4.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="3">                    <input type="hidden" id="PhotoPath" value="../static/img/4.jpg">','2024-03-25 17:06:32.910314');
INSERT INTO "messages" VALUES (2,1,3,'Для тебя новая заявка от юзера! Вот сообщение для тебя: Привет, я Стёпочка, го др, Данил.                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Роктум <img src="../static/img/2.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="3">                    <input type="hidden" id="PhotoPath" value="../static/img/2.jpg">','2024-03-26 02:12:38.112306');
INSERT INTO "messages" VALUES (3,1,4,'Для тебя новая заявка от юзера! Вот сообщение для тебя: Привет, я Стёпочка, го др.                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Паша <img src="../static/img/2.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="4">                    <input type="hidden" id="PhotoPath" value="../static/img/2.jpg">','2024-03-26 02:13:02.156612');
INSERT INTO "messages" VALUES (5,4,2,'Привет ','2024-03-26 02:15:58.636113');
INSERT INTO "messages" VALUES (6,2,4,'привет, пупсик','2024-03-26 02:16:04.119363');
INSERT INTO "messages" VALUES (7,4,2,'Лох','2024-03-26 02:16:04.719144');
INSERT INTO "messages" VALUES (8,2,4,'го встр','2024-03-26 02:16:08.356609');
INSERT INTO "messages" VALUES (9,2,4,'Кто то из вас заблокировал другого. Перезагрузите страницу. Для разблокироваки лайкните его снова(нужно чтобы у обоих людей были взаимные лайки)','2024-03-26 02:16:13.861664');
INSERT INTO "messages" VALUES (10,2,2,'Кто то из вас заблокировал другого. Перезагрузите страницу. Для разблокироваки лайкните его снова(нужно чтобы у обоих людей были взаимные лайки)','2024-03-26 02:16:28.199892');
INSERT INTO "messages" VALUES (11,1,5,'Для тебя новая заявка от юзера! Вот сообщение для тебя: .                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Андрей1984 <img src="../static/img/1.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="5">                    <input type="hidden" id="PhotoPath" value="../static/img/1.jpg">','2024-03-26 02:24:31.511781');
INSERT INTO "messages" VALUES (12,5,5,'Хай','2024-03-26 02:25:17.158655');
INSERT INTO "messages" VALUES (13,5,5,'Хай','2024-03-26 02:25:36.086656');
INSERT INTO "messages" VALUES (14,1,5,'as','2024-03-26 02:25:47.231275');
INSERT INTO "messages" VALUES (15,5,5,'Хай','2024-03-26 02:26:04.273668');
INSERT INTO "messages" VALUES (16,1,5,'Для тебя новая заявка от юзера! Вот сообщение для тебя: .                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Андрей1984 <img src="../static/img/4.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="5">                    <input type="hidden" id="PhotoPath" value="../static/img/4.jpg">','2024-03-26 02:26:48.508417');
INSERT INTO "messages" VALUES (17,4,5,'привет','2024-03-26 02:27:38.795573');
INSERT INTO "messages" VALUES (18,4,5,'Привет','2024-03-26 02:27:45.526402');
INSERT INTO "messages" VALUES (19,5,4,'Хай','2024-03-26 02:28:07.599691');
INSERT INTO "messages" VALUES (20,4,3,'ds','2024-03-26 02:31:45.239094');
INSERT INTO "messages" VALUES (21,4,4,'rda','2024-03-26 02:53:59.780041');
INSERT INTO "messages" VALUES (22,4,5,'sd','2024-03-26 02:54:07.955637');
INSERT INTO "messages" VALUES (23,4,5,'sad','2024-03-26 02:54:10.027467');
INSERT INTO "messages" VALUES (24,4,5,'asd','2024-03-26 02:54:12.106597');
INSERT INTO "messages" VALUES (25,4,5,'qw','2024-03-26 02:54:12.109524');
INSERT INTO "messages" VALUES (26,4,5,'das','2024-03-26 02:54:14.160549');
INSERT INTO "messages" VALUES (27,4,5,'d','2024-03-26 02:59:56.774165');
INSERT INTO "messages" VALUES (28,4,5,'sad','2024-03-26 03:00:02.003083');
INSERT INTO "messages" VALUES (29,1,5,'Для тебя новая заявка от юзера! Вот сообщение для тебя: .                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Андрей1984 <img src="../static/img/6.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="5">                    <input type="hidden" id="PhotoPath" value="../static/img/6.jpg">','2024-03-26 08:08:25.426684');
INSERT INTO "messages" VALUES (31,1,4,'Для тебя новая заявка от юзера! Вот сообщение для тебя: .                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Паша <img src="../static/img/6.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="4">                    <input type="hidden" id="PhotoPath" value="../static/img/6.jpg">','2024-03-26 08:09:36.188937');
INSERT INTO "messages" VALUES (32,1,5,'Для тебя новая заявка от юзера! Вот сообщение для тебя: Саламуля.                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Андрей1984 <img src="../static/img/3.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="5">                    <input type="hidden" id="PhotoPath" value="../static/img/3.jpg">','2024-03-26 10:20:09.573296');
INSERT INTO "messages" VALUES (33,4,3,'Ale','2024-03-26 10:27:35.354037');
INSERT INTO "messages" VALUES (34,1,1,'Для тебя новая заявка от юзера! Вот сообщение для тебя: .                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Administrator <img src="../static/img/12.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="1">                    <input type="hidden" id="PhotoPath" value="../static/img/12.jpg">','2024-03-26 12:59:39.009715');
INSERT INTO "messages" VALUES (35,6,4,'Ты лучший!!!','2024-03-26 22:56:55.126329');
INSERT INTO "messages" VALUES (36,1,3,'Для тебя новая заявка от юзера! Вот сообщение для тебя: Привет
.                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Ульяна <img src="../static/img/5.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="3">                    <input type="hidden" id="PhotoPath" value="../static/img/5.jpg">','2024-03-26 22:59:37.395746');
INSERT INTO "messages" VALUES (37,1,6,'Для тебя новая заявка от юзера! Вот сообщение для тебя: .                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Ульяна <img src="../static/img/5.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="6">                    <input type="hidden" id="PhotoPath" value="../static/img/5.jpg">','2024-03-26 23:07:42.951727');
INSERT INTO "messages" VALUES (39,6,5,'Привет!','2024-03-26 23:09:25.689257');
INSERT INTO "messages" VALUES (40,6,5,'Встретимся? 😃🤭🤫','2024-03-26 23:09:45.382731');
INSERT INTO "messages" VALUES (41,6,5,'Ты мне нравишься 😉🤪😘','2024-03-26 23:10:06.458613');
INSERT INTO "messages" VALUES (42,5,6,'Привет','2024-03-26 23:10:46.263405');
INSERT INTO "messages" VALUES (43,5,6,'Ты мне тоже нравишься😍','2024-03-26 23:11:10.396540');
INSERT INTO "messages" VALUES (44,5,6,'Давай дружить😃😘','2024-03-26 23:11:28.963243');
INSERT INTO "messages" VALUES (45,6,5,'Ну приходи в дровеник, я там дрова складываю 😆😆😆','2024-03-26 23:12:01.661910');
INSERT INTO "messages" VALUES (46,4,6,'Спасибо','2024-03-27 00:10:50.230694');
INSERT INTO "messages" VALUES (47,4,6,'Я люблю тебя','2024-03-27 00:10:58.631409');
INSERT INTO "messages" VALUES (48,6,4,'И я тебя 😍😍😍','2024-03-27 00:11:38.927192');
INSERT INTO "messages" VALUES (49,1,6,'Для тебя новая заявка от юзера! Вот сообщение для тебя: Мамуля лучшая😎😎.                     Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>                    <button class="btn btn-danger disaccept">Отклонить</button>                    
 Имя: Ульяна <img src="../static/img/2.jpg" id="PhotoPathc">                     <input type="hidden" id="user_id" value="6">                    <input type="hidden" id="PhotoPath" value="../static/img/2.jpg">','2024-03-27 00:15:38.939736');
INSERT INTO "messages" VALUES (50,1,5,'s','2024-03-27 00:26:22.857651');
CREATE INDEX IF NOT EXISTS "ix_messages_timestamp" ON "messages" (
	"timestamp"
);
COMMIT;
