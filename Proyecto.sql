-- MySQL dump 10.13  Distrib 9.5.0, for Win64 (x86_64)
--
-- Host: localhost    Database: Proyecto
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `archivos_compartidos`
--

DROP TABLE IF EXISTS `archivos_compartidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archivos_compartidos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `contacto_id` int NOT NULL,
  `ruta_archivo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cifrado` tinyint(1) DEFAULT '1',
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archivos_compartidos`
--

LOCK TABLES `archivos_compartidos` WRITE;
/*!40000 ALTER TABLE `archivos_compartidos` DISABLE KEYS */;
INSERT INTO `archivos_compartidos` VALUES (1,1,5,'/srv/archivos/angelg/descargar_archivo.sh',0,'2025-12-08 00:21:48'),(2,1,9,'/srv/archivos/angelg/agregar_contacto.sh',0,'2025-12-08 00:25:18'),(3,57,56,'',0,'2025-12-08 01:45:23');
/*!40000 ALTER TABLE `archivos_compartidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contactos`
--

DROP TABLE IF EXISTS `contactos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contactos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `contacto_id` int NOT NULL,
  `puede_enviar_archivos` tinyint(1) DEFAULT '1',
  `agregado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_contacto` (`usuario_id`,`contacto_id`),
  KEY `fk_contacto_contacto` (`contacto_id`),
  CONSTRAINT `fk_contacto_contacto` FOREIGN KEY (`contacto_id`) REFERENCES `usuarios_sync` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_contacto_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios_sync` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contactos`
--

LOCK TABLES `contactos` WRITE;
/*!40000 ALTER TABLE `contactos` DISABLE KEYS */;
INSERT INTO `contactos` VALUES (1,1,2,1,'2025-12-07 23:37:45'),(2,1,65,1,'2025-12-07 23:50:13'),(4,66,65,1,'2025-12-08 01:32:39');
/*!40000 ALTER TABLE `contactos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventos_sync`
--

DROP TABLE IF EXISTS `eventos_sync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventos_sync` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `accion` enum('CREADO','MODIFICADO','ELIMINADO') NOT NULL,
  `origen` enum('WINDOWS','LINUX') NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `detalle` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=203 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventos_sync`
--

LOCK TABLES `eventos_sync` WRITE;
/*!40000 ALTER TABLE `eventos_sync` DISABLE KEYS */;
INSERT INTO `eventos_sync` VALUES (1,'angelg','CREADO','LINUX','2025-11-30 19:59:03','Usuario creado en sistema origen'),(2,'testuser','CREADO','LINUX','2025-11-30 20:02:13','Usuario creado en sistema origen'),(3,'testuser','MODIFICADO','LINUX','2025-11-30 20:03:05','Usuario modificado'),(4,'testuser1','CREADO','LINUX','2025-11-30 20:03:18','Usuario creado en sistema origen'),(5,'otrotest','CREADO','LINUX','2025-11-30 20:05:53','Usuario creado en sistema origen'),(6,'otrotest1','CREADO','LINUX','2025-11-30 20:09:02','Usuario creado en sistema origen'),(7,'otrotest','MODIFICADO','LINUX','2025-11-30 20:40:19','Usuario modificado'),(8,'otrotest1','MODIFICADO','LINUX','2025-11-30 21:14:45','Usuario modificado'),(9,'otrotest2','CREADO','LINUX','2025-11-30 21:15:00','Usuario creado en sistema origen'),(10,'angelg','MODIFICADO','LINUX','2025-11-30 23:39:01','Usuario modificado'),(11,'angelg22','CREADO','WINDOWS','2025-11-30 23:42:25','Usuario creado en sistema origen'),(12,'angelg22','MODIFICADO','WINDOWS','2025-11-30 23:43:31','Usuario modificado'),(13,'angelg22','MODIFICADO','WINDOWS','2025-11-30 23:44:44','Usuario modificado'),(14,'otrotest','MODIFICADO','LINUX','2025-11-30 23:45:33','Usuario modificado'),(16,'angelgPrueba','CREADO','LINUX','2025-12-03 18:36:30','Usuario creado en sistema origen'),(18,'angelg22','CREADO','LINUX','2025-12-03 19:01:33','Error al procesar usuario angelg22'),(20,'angelg22','CREADO','LINUX','2025-12-03 19:05:13','Error al procesar usuario angelg22'),(22,'angelSincronizacion','CREADO','LINUX','2025-12-03 19:08:25','Usuario creado en sistema origen'),(23,'angelSincronizacion1','CREADO','LINUX','2025-12-03 19:09:23','Usuario creado en sistema origen'),(24,'angelSincronizacion2','CREADO','LINUX','2025-12-03 19:12:39','Usuario creado en sistema origen'),(25,'angelSincronizacion3','CREADO','LINUX','2025-12-03 19:16:20','Usuario creado en sistema origen'),(26,'angelSincronizacion4','CREADO','LINUX','2025-12-03 19:17:06','Usuario creado en sistema origen'),(27,'angelSincronizacion5','CREADO','LINUX','2025-12-03 19:17:30','Usuario creado en sistema origen'),(28,'angelSincronizacion6','CREADO','LINUX','2025-12-03 19:20:51','Usuario creado en sistema origen'),(29,'angelSincronizacion7','CREADO','LINUX','2025-12-04 19:21:49','Usuario creado en sistema origen'),(30,'Sincronizacion10','CREADO','WINDOWS','2025-12-04 19:26:14','Usuario creado en sistema origen'),(32,'Sincronizacion10','CREADO','LINUX','2025-12-04 19:26:49','Error al procesar usuario Sincronizacion10'),(34,'pruebac','CREADO','WINDOWS','2025-12-04 19:32:00','Usuario creado en sistema origen'),(36,'pruebac','CREADO','LINUX','2025-12-04 19:32:23','Error al procesar usuario pruebac'),(38,'angel123','CREADO','WINDOWS','2025-12-04 19:37:47','Usuario creado en sistema origen'),(40,'angel123','CREADO','LINUX','2025-12-04 19:37:55','Error al procesar usuario angel123'),(42,'angelg789','CREADO','WINDOWS','2025-12-04 19:40:27','Usuario creado en sistema origen'),(47,'Sincronizacion10','MODIFICADO','WINDOWS','2025-12-04 19:47:56','Usuario modificado'),(48,'pruebac','MODIFICADO','WINDOWS','2025-12-04 19:47:57','Usuario modificado'),(49,'angel123','MODIFICADO','WINDOWS','2025-12-04 19:47:57','Usuario modificado'),(50,'angelg789','MODIFICADO','WINDOWS','2025-12-04 19:47:57','Usuario modificado'),(51,'angelgPruebaB','CREADO','WINDOWS','2025-12-04 19:54:34','Usuario creado en sistema origen'),(52,'angelgPruebaB','MODIFICADO','WINDOWS','2025-12-04 19:54:49','Usuario modificado'),(53,'angelgPruebaw','CREADO','LINUX','2025-12-04 19:55:46','Usuario creado en sistema origen'),(54,'angelgPruebaw','MODIFICADO','LINUX','2025-12-04 19:55:59','Usuario modificado'),(55,'angelgPruebaw','MODIFICADO','LINUX','2025-12-04 19:56:00','Usuario modificado'),(56,'angelgPruebaL','CREADO','WINDOWS','2025-12-04 20:01:07','Usuario creado en sistema origen'),(57,'OtroUsuarioPrueba','CREADO','WINDOWS','2025-12-04 20:03:51','Usuario creado en sistema origen'),(58,'OtroUsuarioPrueba','MODIFICADO','WINDOWS','2025-12-04 20:03:53','Usuario modificado'),(59,'OtroUsuarioPrueba1','CREADO','WINDOWS','2025-12-04 20:05:02','Usuario creado en sistema origen'),(60,'angelgPruebaL','MODIFICADO','WINDOWS','2025-12-04 20:05:10','Usuario modificado'),(61,'OtroUsuarioPrueba','MODIFICADO','WINDOWS','2025-12-04 20:05:14','Usuario modificado'),(62,'OtroUsuarioPrueba1','MODIFICADO','WINDOWS','2025-12-04 20:05:18','Usuario modificado'),(63,'testLinux','CREADO','LINUX','2025-12-04 20:06:22','Usuario creado en sistema origen'),(64,'testLinux','MODIFICADO','LINUX','2025-12-04 20:08:29','Usuario modificado'),(65,'testLinux3','CREADO','LINUX','2025-12-04 20:08:48','Usuario creado en sistema origen'),(66,'angelgPruebaw','MODIFICADO','LINUX','2025-12-04 20:09:19','Usuario modificado'),(67,'testLinux','MODIFICADO','LINUX','2025-12-04 20:09:19','Usuario modificado'),(68,'testLinux','MODIFICADO','LINUX','2025-12-04 20:09:20','Usuario modificado'),(69,'testLinux','MODIFICADO','LINUX','2025-12-04 20:09:20','Usuario modificado'),(70,'testLinux','MODIFICADO','LINUX','2025-12-04 20:09:21','Usuario modificado'),(71,'testLinux3','MODIFICADO','LINUX','2025-12-04 20:09:22','Usuario modificado'),(72,'testLinux3','MODIFICADO','LINUX','2025-12-04 20:09:22','Usuario modificado'),(73,'testLinux4','CREADO','LINUX','2025-12-04 20:22:29','Usuario creado en sistema origen'),(74,'testLinux4','MODIFICADO','LINUX','2025-12-04 20:23:12','Usuario modificado'),(75,'testLinux4','MODIFICADO','LINUX','2025-12-04 20:23:13','Usuario modificado'),(76,'testLinux4','MODIFICADO','LINUX','2025-12-04 20:26:47','Usuario modificado'),(77,'angelg90','CREADO','LINUX','2025-12-04 20:39:48','Usuario creado en sistema origen'),(78,'angelg90','MODIFICADO','LINUX','2025-12-04 20:40:08','Usuario modificado'),(79,'angelg90','MODIFICADO','LINUX','2025-12-04 20:40:09','Usuario modificado'),(80,'angelg99','CREADO','LINUX','2025-12-04 20:52:36','Usuario creado en sistema origen'),(81,'angelg99','MODIFICADO','LINUX','2025-12-04 20:53:12','Usuario modificado'),(82,'angelg99','MODIFICADO','LINUX','2025-12-04 20:53:12','Usuario modificado'),(83,'angel100','CREADO','WINDOWS','2025-12-04 21:22:20','Usuario creado en sistema origen'),(84,'angel100','MODIFICADO','WINDOWS','2025-12-04 21:32:05','Usuario modificado'),(85,'teUsuario','CREADO','LINUX','2025-12-05 00:05:02','Usuario creado en sistema origen'),(86,'teUsuario','MODIFICADO','LINUX','2025-12-05 00:08:44','Usuario modificado'),(87,'angel100','MODIFICADO','WINDOWS','2025-12-05 00:10:30','Usuario modificado'),(88,'teUsuario','MODIFICADO','LINUX','2025-12-05 00:13:16','Usuario modificado'),(89,'teUsuario','MODIFICADO','LINUX','2025-12-05 00:13:17','Usuario modificado'),(90,'teUsuario','MODIFICADO','LINUX','2025-12-05 00:13:17','Usuario modificado'),(91,'teUsuario','MODIFICADO','LINUX','2025-12-05 00:13:17','Usuario modificado'),(92,'teUsuario','MODIFICADO','LINUX','2025-12-05 00:14:40','Usuario modificado'),(93,'teUsuario2','CREADO','WINDOWS','2025-12-05 00:15:23','Usuario creado en sistema origen'),(94,'teUsuario','MODIFICADO','LINUX','2025-12-05 00:16:03','Usuario modificado'),(95,'teUsuario2','MODIFICADO','WINDOWS','2025-12-05 00:16:08','Usuario modificado'),(96,'teUsuario2','MODIFICADO','WINDOWS','2025-12-05 00:16:09','Usuario modificado'),(97,'usuarioMod','CREADO','LINUX','2025-12-05 00:55:49','Usuario creado en sistema origen'),(98,'teUsuario','MODIFICADO','LINUX','2025-12-05 00:56:13','Usuario modificado'),(99,'usuarioMod','MODIFICADO','LINUX','2025-12-05 00:56:14','Usuario modificado'),(100,'usuarioMod','MODIFICADO','LINUX','2025-12-05 00:56:14','Usuario modificado'),(101,'usuarioModi','MODIFICADO','LINUX','2025-12-05 00:57:26','Usuario modificado'),(102,'usuarioModi','MODIFICADO','LINUX','2025-12-05 00:57:50','Usuario modificado'),(103,'usuarioMod2','CREADO','LINUX','2025-12-05 01:00:52','Usuario creado en sistema origen'),(104,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:01:29','Usuario modificado'),(105,'usuarioMod2','MODIFICADO','LINUX','2025-12-05 01:01:29','Usuario modificado'),(106,'usuarioMod2','MODIFICADO','LINUX','2025-12-05 01:01:30','Usuario modificado'),(107,'modi','MODIFICADO','LINUX','2025-12-05 01:02:23','Usuario modificado'),(108,'modificar','CREADO','LINUX','2025-12-05 01:09:34','Usuario creado en sistema origen'),(109,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:09:45','Usuario modificado'),(110,'modi','MODIFICADO','LINUX','2025-12-05 01:09:45','Usuario modificado'),(111,'modificar','MODIFICADO','LINUX','2025-12-05 01:09:46','Usuario modificado'),(112,'modificar','MODIFICADO','LINUX','2025-12-05 01:09:46','Usuario modificado'),(113,'mod','MODIFICADO','LINUX','2025-12-05 01:10:19','Usuario modificado'),(114,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:10:35','Usuario modificado'),(115,'modi','MODIFICADO','LINUX','2025-12-05 01:10:36','Usuario modificado'),(116,'mod','MODIFICADO','LINUX','2025-12-05 01:10:37','Usuario modificado'),(117,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:15:44','Usuario modificado'),(118,'modi','MODIFICADO','LINUX','2025-12-05 01:15:45','Usuario modificado'),(119,'mod','MODIFICADO','LINUX','2025-12-05 01:15:46','Usuario modificado'),(120,'mod','MODIFICADO','LINUX','2025-12-05 01:17:33','Usuario modificado'),(121,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:18:06','Usuario modificado'),(122,'modi','MODIFICADO','LINUX','2025-12-05 01:18:06','Usuario modificado'),(123,'mod','MODIFICADO','LINUX','2025-12-05 01:18:07','Usuario modificado'),(124,'testmod','CREADO','LINUX','2025-12-05 01:19:34','Usuario creado en sistema origen'),(125,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:19:43','Usuario modificado'),(126,'modi','MODIFICADO','LINUX','2025-12-05 01:19:44','Usuario modificado'),(127,'testmod','MODIFICADO','LINUX','2025-12-05 01:19:44','Usuario modificado'),(128,'testmod','MODIFICADO','LINUX','2025-12-05 01:19:45','Usuario modificado'),(129,'testmod30','MODIFICADO','LINUX','2025-12-05 01:22:07','Usuario modificado'),(130,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:22:52','Usuario modificado'),(131,'modi','MODIFICADO','LINUX','2025-12-05 01:22:52','Usuario modificado'),(132,'testmod30','MODIFICADO','LINUX','2025-12-05 01:22:53','Usuario modificado'),(133,'testmod1','CREADO','LINUX','2025-12-05 01:25:56','Usuario creado en sistema origen'),(134,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:26:07','Usuario modificado'),(135,'modi','MODIFICADO','LINUX','2025-12-05 01:26:08','Usuario modificado'),(136,'testmod30','MODIFICADO','LINUX','2025-12-05 01:26:09','Usuario modificado'),(137,'testmod1','MODIFICADO','LINUX','2025-12-05 01:26:09','Usuario modificado'),(138,'testmod1','MODIFICADO','LINUX','2025-12-05 01:26:09','Usuario modificado'),(139,'testmod50','MODIFICADO','LINUX','2025-12-05 01:26:43','Usuario modificado'),(140,'lol','MODIFICADO','LINUX','2025-12-05 01:31:05','Usuario modificado'),(141,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:31:18','Usuario modificado'),(142,'modi','MODIFICADO','LINUX','2025-12-05 01:31:18','Usuario modificado'),(143,'testmod30','MODIFICADO','LINUX','2025-12-05 01:31:19','Usuario modificado'),(144,'lol','MODIFICADO','LINUX','2025-12-05 01:31:20','Usuario modificado'),(145,'renombrar','CREADO','WINDOWS','2025-12-05 01:33:25','Usuario creado en sistema origen'),(146,'teUsuario2','MODIFICADO','WINDOWS','2025-12-05 01:33:59','Usuario modificado'),(147,'mod','MODIFICADO','LINUX','2025-12-05 01:33:59','Usuario modificado'),(148,'renombrar','MODIFICADO','WINDOWS','2025-12-05 01:34:01','Usuario modificado'),(149,'renombrar','MODIFICADO','WINDOWS','2025-12-05 01:34:01','Usuario modificado'),(150,'renombrar','MODIFICADO','WINDOWS','2025-12-05 01:34:29','Usuario modificado'),(151,'angelmod','CREADO','LINUX','2025-12-05 01:50:16','Usuario creado en sistema origen'),(152,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:50:32','Usuario modificado'),(153,'modi','MODIFICADO','LINUX','2025-12-05 01:50:33','Usuario modificado'),(154,'testmod30','MODIFICADO','LINUX','2025-12-05 01:50:35','Usuario modificado'),(155,'lol','MODIFICADO','LINUX','2025-12-05 01:50:37','Usuario modificado'),(156,'angelmod','MODIFICADO','LINUX','2025-12-05 01:50:38','Usuario modificado'),(157,'angelmod','MODIFICADO','LINUX','2025-12-05 01:50:39','Usuario modificado'),(158,'angelg21','MODIFICADO','LINUX','2025-12-05 01:51:49','Usuario modificado'),(159,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:52:09','Usuario modificado'),(160,'modi','MODIFICADO','LINUX','2025-12-05 01:52:09','Usuario modificado'),(161,'testmod30','MODIFICADO','LINUX','2025-12-05 01:52:10','Usuario modificado'),(162,'lol','MODIFICADO','LINUX','2025-12-05 01:52:11','Usuario modificado'),(163,'angelg21','MODIFICADO','LINUX','2025-12-05 01:52:12','Usuario modificado'),(164,'usuarioModi','MODIFICADO','LINUX','2025-12-05 01:52:37','Usuario modificado'),(165,'modi','MODIFICADO','LINUX','2025-12-05 01:52:38','Usuario modificado'),(166,'testmod30','MODIFICADO','LINUX','2025-12-05 01:52:38','Usuario modificado'),(167,'lol','MODIFICADO','LINUX','2025-12-05 01:52:39','Usuario modificado'),(168,'angelg21','MODIFICADO','LINUX','2025-12-05 01:52:40','Usuario modificado'),(169,'usuarioModi','MODIFICADO','LINUX','2025-12-05 02:19:19','Usuario modificado'),(170,'modi','MODIFICADO','LINUX','2025-12-05 02:19:20','Usuario modificado'),(171,'testmod30','MODIFICADO','LINUX','2025-12-05 02:19:20','Usuario modificado'),(172,'lol','MODIFICADO','LINUX','2025-12-05 02:19:21','Usuario modificado'),(173,'angelg21','MODIFICADO','LINUX','2025-12-05 02:19:21','Usuario modificado'),(174,'ang','CREADO','LINUX','2025-12-05 02:32:19','Usuario creado en sistema origen'),(175,'ang','MODIFICADO','LINUX','2025-12-05 02:32:28','Usuario modificado'),(176,'ang','MODIFICADO','LINUX','2025-12-05 02:32:28','Usuario modificado'),(177,'angelw','CREADO','WINDOWS','2025-12-05 03:08:01','Usuario creado en sistema origen'),(178,'angelq','CREADO','WINDOWS','2025-12-05 03:19:50','Usuario creado en sistema origen'),(179,'angelq','MODIFICADO','WINDOWS','2025-12-05 03:20:00','Usuario modificado'),(180,'angelq','MODIFICADO','WINDOWS','2025-12-05 03:20:01','Usuario modificado'),(181,'angelqq','CREADO','WINDOWS','2025-12-05 03:32:07','Usuario creado en sistema origen'),(182,'angelq','MODIFICADO','WINDOWS','2025-12-05 03:32:28','Usuario modificado'),(183,'angelqq','MODIFICADO','WINDOWS','2025-12-05 03:32:35','Usuario modificado'),(184,'angelqq','MODIFICADO','WINDOWS','2025-12-05 03:32:35','Usuario modificado'),(185,'angelqq','MODIFICADO','WINDOWS','2025-12-05 03:39:54','Usuario modificado'),(186,'angelqq','MODIFICADO','WINDOWS','2025-12-05 03:41:22','Usuario modificado'),(187,'angelqqs','CREADO','WINDOWS','2025-12-05 03:41:44','Usuario creado en sistema origen'),(188,'angelqqs','MODIFICADO','WINDOWS','2025-12-05 03:41:52','Usuario modificado'),(189,'angelqqs','MODIFICADO','WINDOWS','2025-12-05 03:41:52','Usuario modificado'),(190,'angelggg','CREADO','LINUX','2025-12-05 03:43:33','Usuario creado en sistema origen'),(191,'angelggg','MODIFICADO','LINUX','2025-12-05 03:43:52','Usuario modificado'),(192,'angelggg','MODIFICADO','LINUX','2025-12-05 03:43:52','Usuario modificado'),(193,'angelqqs','MODIFICADO','WINDOWS','2025-12-05 03:44:33','Usuario modificado'),(194,'angelggg','MODIFICADO','LINUX','2025-12-05 03:45:16','Usuario modificado'),(195,'angelg65','CREADO','LINUX','2025-12-08 00:49:36','Usuario creado en sistema origen'),(196,'angelggg','MODIFICADO','LINUX','2025-12-08 00:50:32','Usuario modificado'),(197,'angelg65','MODIFICADO','LINUX','2025-12-08 00:50:33','Usuario modificado'),(198,'testuser','MODIFICADO','LINUX','2025-12-08 00:56:42','Usuario modificado'),(199,'angelg90','MODIFICADO','LINUX','2025-12-08 01:44:38','Usuario modificado'),(200,'angelg','MODIFICADO','LINUX','2025-12-08 01:55:53','Usuario modificado'),(201,'190292','CREADO','WINDOWS','2025-12-08 02:00:46','Usuario creado en sistema origen'),(202,'slkfkljsdf','CREADO','WINDOWS','2025-12-08 02:01:55','Usuario creado en sistema origen');
/*!40000 ALTER TABLE `eventos_sync` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs_sync`
--

DROP TABLE IF EXISTS `logs_sync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs_sync` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_usuario_sync` int NOT NULL,
  `evento` varchar(100) NOT NULL,
  `sistema` enum('linux','windows') NOT NULL,
  `mensaje` text,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_usuario_sync` (`id_usuario_sync`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_sync`
--

LOCK TABLES `logs_sync` WRITE;
/*!40000 ALTER TABLE `logs_sync` DISABLE KEYS */;
INSERT INTO `logs_sync` VALUES (1,1,'CREADO','linux','Usuario procesado correctamente en Linux','2025-11-30 20:59:03'),(2,2,'CREADO','linux','Usuario procesado correctamente en Linux','2025-11-30 21:02:13'),(3,2,'CREADO','linux','Usuario procesado correctamente en Linux','2025-11-30 21:03:05'),(4,4,'CREADO','linux','Usuario procesado correctamente en Linux','2025-11-30 21:03:18'),(5,5,'CREADO','linux','Usuario procesado correctamente en Linux','2025-11-30 21:05:53'),(6,6,'CREADO','linux','Usuario procesado correctamente en Linux','2025-11-30 21:09:03'),(7,6,'CREADO','linux','Usuario procesado correctamente en Linux','2025-11-30 22:14:45'),(8,8,'CREADO','linux','Usuario procesado correctamente en Linux','2025-11-30 22:15:00'),(9,1,'CREADO','windows','Usuario procesado correctamente en Windows','2025-12-01 00:39:01'),(10,10,'CREADO','windows','Usuario procesado correctamente en Windows','2025-12-01 00:42:26'),(11,10,'CREADO','windows','Usuario procesado correctamente en Windows','2025-12-01 00:43:32'),(12,10,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-01 00:44:44'),(13,5,'CREADO','windows','Usuario procesado correctamente en Windows','2025-12-01 00:45:33'),(14,5,'CREADO','windows','Usuario procesado correctamente en Windows','2025-12-03 18:50:31'),(15,0,'CREAR_EXITOSO','windows','[OK] Usuario creado. Password: PQuRD&Heq8','2025-12-03 19:35:03'),(16,15,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-03 19:36:30'),(17,10,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-03 20:01:32'),(18,10,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-03 20:05:13'),(19,19,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-03 20:08:25'),(20,20,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-03 20:09:23'),(21,21,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-03 20:12:39'),(22,22,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-03 20:16:20'),(23,23,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-03 20:17:07'),(24,24,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-03 20:17:31'),(25,25,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-03 20:20:51'),(26,26,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-04 20:21:49'),(27,27,'CREADO','windows','Usuario procesado correctamente en Windows','2025-12-04 20:26:14'),(28,27,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-04 20:26:48'),(29,30,'CREADO','windows','Usuario procesado correctamente en Windows','2025-12-04 20:32:01'),(30,30,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-04 20:32:23'),(31,33,'CREADO','windows','Usuario procesado correctamente en Windows','2025-12-04 20:37:47'),(32,33,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-04 20:37:55'),(33,33,'CREADO','linux','Usuario creado correctamente en Linux','2025-12-04 20:37:55'),(34,35,'CREADO','windows','Usuario procesado correctamente en Windows','2025-12-04 20:40:27'),(35,36,'CREADO','windows','Usuario procesado correctamente en Windows','2025-12-04 20:54:34'),(36,37,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-04 20:55:46'),(37,38,'CREADO','windows','Usuario procesado correctamente en Windows','2025-12-04 21:01:08'),(38,39,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-04 21:03:51'),(39,39,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-04 21:03:53'),(40,41,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-04 21:05:02'),(41,42,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-04 21:06:22'),(42,42,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-04 21:08:29'),(43,44,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-04 21:08:48'),(44,45,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-04 21:22:30'),(45,46,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-04 21:39:48'),(46,47,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-04 21:52:36'),(47,48,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-04 22:22:20'),(48,10,'ELIMINADO','windows','Usuario Windows eliminado','2025-12-05 00:33:58'),(49,49,'CREADO','linux','Usuario Linux creado y llaves SSH generadas','2025-12-05 01:05:02'),(50,49,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-05 01:14:40'),(51,51,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-05 01:15:23'),(52,52,'CREADO','linux','Usuario Linux creado y llaves SSH generadas','2025-12-05 01:55:49'),(53,53,'CREADO','linux','Usuario Linux creado y llaves SSH generadas','2025-12-05 02:00:52'),(54,54,'CREADO','linux','Usuario Linux creado y llaves SSH generadas','2025-12-05 02:09:34'),(55,54,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-05 02:17:33'),(56,56,'CREADO','linux','Usuario Linux creado y llaves SSH generadas','2025-12-05 02:19:34'),(57,57,'CREADO','linux','Usuario Linux creado y llaves SSH generadas','2025-12-05 02:25:57'),(58,58,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-05 02:33:25'),(59,59,'CREADO','linux','Usuario Linux creado y llaves SSH generadas','2025-12-05 02:50:16'),(60,60,'CREADO','linux','Usuario Linux creado y llaves SSH generadas','2025-12-05 03:32:19'),(61,61,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-05 04:08:01'),(62,62,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-05 04:19:51'),(63,63,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-05 04:32:08'),(64,64,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-05 04:41:44'),(65,65,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-05 04:43:34'),(66,65,'ELIMINADO','windows','Usuario Windows eliminado','2025-12-05 04:44:19'),(67,66,'CREADO','linux','Usuario procesado correctamente en Linux','2025-12-08 01:49:36'),(68,46,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-08 02:44:38'),(69,1,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-08 02:55:54'),(70,69,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-08 03:00:46'),(71,70,'CREADO','windows','Usuario Windows creado y llaves SSH generadas','2025-12-08 03:01:56');
/*!40000 ALTER TABLE `logs_sync` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pendientes_sync`
--

DROP TABLE IF EXISTS `pendientes_sync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pendientes_sync` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `accion` enum('CREAR','MODIFICAR','ELIMINAR') NOT NULL,
  `destino` enum('WINDOWS','LINUX') NOT NULL,
  `procesado` tinyint(1) DEFAULT '0',
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pendientes_sync`
--

LOCK TABLES `pendientes_sync` WRITE;
/*!40000 ALTER TABLE `pendientes_sync` DISABLE KEYS */;
INSERT INTO `pendientes_sync` VALUES (1,'testLinux4','CREAR','WINDOWS',1,'2025-12-04 20:22:29'),(2,'testLinux4','CREAR','WINDOWS',1,'2025-12-04 20:22:30'),(3,'testLinux4','MODIFICAR','WINDOWS',1,'2025-12-04 20:23:12'),(12,'angel100','CREAR','LINUX',1,'2025-12-04 21:22:20'),(13,'angel100','CREAR','LINUX',1,'2025-12-04 21:22:21'),(14,'angel100','CREAR','LINUX',1,'2025-12-04 21:31:52'),(15,'angel100','MODIFICAR','LINUX',1,'2025-12-04 21:32:05'),(16,'teUsuario','CREAR','WINDOWS',1,'2025-12-05 00:05:02'),(17,'teUsuario','CREAR','WINDOWS',1,'2025-12-05 00:05:02'),(18,'teUsuario','ELIMINAR','WINDOWS',1,'2025-12-05 00:08:44'),(19,'teUsuario','MODIFICAR','WINDOWS',1,'2025-12-05 00:08:44'),(20,'teUsuario','CREAR','LINUX',1,'2025-12-05 00:14:40'),(21,'teUsuario2','CREAR','LINUX',1,'2025-12-05 00:15:23'),(22,'teUsuario2','CREAR','LINUX',1,'2025-12-05 00:15:23'),(23,'teUsuario2','MODIFICAR','LINUX',1,'2025-12-05 00:16:08'),(24,'usuarioMod','CREAR','WINDOWS',1,'2025-12-05 00:55:49'),(25,'usuarioMod','CREAR','WINDOWS',1,'2025-12-05 00:55:49'),(26,'usuarioMod','MODIFICAR','WINDOWS',1,'2025-12-05 00:56:14'),(27,'usuarioModi','MODIFICAR','WINDOWS',1,'2025-12-05 00:57:26'),(28,'usuarioMod2','CREAR','WINDOWS',1,'2025-12-05 01:00:52'),(29,'usuarioMod2','CREAR','WINDOWS',1,'2025-12-05 01:00:52'),(30,'usuarioMod2','MODIFICAR','WINDOWS',1,'2025-12-05 01:01:29'),(31,'modi','MODIFICAR','WINDOWS',1,'2025-12-05 01:02:23'),(32,'modificar','CREAR','WINDOWS',1,'2025-12-05 01:09:34'),(33,'modificar','CREAR','WINDOWS',1,'2025-12-05 01:09:34'),(34,'modificar','MODIFICAR','WINDOWS',1,'2025-12-05 01:09:46'),(35,'mod','MODIFICAR','WINDOWS',1,'2025-12-05 01:10:19'),(36,'mod','CREAR','LINUX',1,'2025-12-05 01:17:33'),(37,'testmod','CREAR','WINDOWS',1,'2025-12-05 01:19:34'),(38,'testmod','CREAR','WINDOWS',1,'2025-12-05 01:19:34'),(39,'testmod','MODIFICAR','WINDOWS',1,'2025-12-05 01:19:44'),(40,'testmod30','MODIFICAR','WINDOWS',1,'2025-12-05 01:22:07'),(41,'testmod1','CREAR','WINDOWS',1,'2025-12-05 01:25:56'),(42,'testmod1','CREAR','WINDOWS',1,'2025-12-05 01:25:57'),(43,'testmod1','MODIFICAR','WINDOWS',1,'2025-12-05 01:26:09'),(44,'testmod50','MODIFICAR','WINDOWS',1,'2025-12-05 01:26:43'),(45,'lol','MODIFICAR','WINDOWS',1,'2025-12-05 01:31:05'),(46,'renombrar','CREAR','LINUX',1,'2025-12-05 01:33:25'),(47,'renombrar','CREAR','LINUX',1,'2025-12-05 01:33:25'),(48,'mod','MODIFICAR','WINDOWS',1,'2025-12-05 01:33:59'),(49,'renombrar','MODIFICAR','LINUX',1,'2025-12-05 01:34:01'),(50,'angelmod','CREAR','WINDOWS',1,'2025-12-05 01:50:16'),(51,'angelmod','CREAR','WINDOWS',1,'2025-12-05 01:50:16'),(52,'angelmod','MODIFICAR','WINDOWS',1,'2025-12-05 01:50:38'),(53,'angelg21','MODIFICAR','WINDOWS',1,'2025-12-05 01:51:49'),(54,'ang','CREAR','WINDOWS',1,'2025-12-05 02:32:19'),(55,'ang','CREAR','WINDOWS',1,'2025-12-05 02:32:19'),(56,'ang','MODIFICAR','WINDOWS',1,'2025-12-05 02:32:28'),(57,'angelw','CREAR','LINUX',1,'2025-12-05 03:08:01'),(58,'angelw','CREAR','LINUX',1,'2025-12-05 03:08:01'),(59,'angelq','CREAR','LINUX',1,'2025-12-05 03:19:50'),(60,'angelq','CREAR','LINUX',1,'2025-12-05 03:19:51'),(61,'angelq','MODIFICAR','LINUX',1,'2025-12-05 03:20:00'),(62,'angelqq','CREAR','LINUX',1,'2025-12-05 03:32:07'),(63,'angelqq','CREAR','LINUX',1,'2025-12-05 03:32:08'),(64,'angelqq','MODIFICAR','LINUX',1,'2025-12-05 03:32:35'),(65,'angelqqs','CREAR','LINUX',1,'2025-12-05 03:41:44'),(66,'angelqqs','CREAR','LINUX',1,'2025-12-05 03:41:44'),(67,'angelqqs','MODIFICAR','LINUX',1,'2025-12-05 03:41:52'),(68,'angelggg','CREAR','WINDOWS',1,'2025-12-05 03:43:33'),(69,'angelggg','CREAR','WINDOWS',1,'2025-12-05 03:43:34'),(70,'angelggg','MODIFICAR','WINDOWS',1,'2025-12-05 03:43:52'),(71,'angelggg','ELIMINAR','WINDOWS',1,'2025-12-05 03:45:16'),(72,'angelg65','CREAR','WINDOWS',1,'2025-12-08 00:49:36'),(73,'angelggg','MODIFICAR','WINDOWS',1,'2025-12-08 00:50:32'),(74,'angelg65','MODIFICAR','WINDOWS',1,'2025-12-08 00:50:33'),(75,'testuser','ELIMINAR','WINDOWS',1,'2025-12-08 00:56:29'),(76,'testuser','MODIFICAR','WINDOWS',0,'2025-12-08 00:56:42'),(77,'angelg90','MODIFICAR','WINDOWS',0,'2025-12-08 01:44:38'),(78,'angelg90','CREAR','LINUX',0,'2025-12-08 01:44:38'),(79,'angelg','MODIFICAR','WINDOWS',0,'2025-12-08 01:55:53'),(80,'angelg','CREAR','LINUX',0,'2025-12-08 01:55:54'),(81,'190292','CREAR','LINUX',0,'2025-12-08 02:00:46'),(82,'190292','CREAR','LINUX',0,'2025-12-08 02:00:46'),(83,'slkfkljsdf','CREAR','LINUX',0,'2025-12-08 02:01:55'),(84,'slkfkljsdf','CREAR','LINUX',0,'2025-12-08 02:01:56');
/*!40000 ALTER TABLE `pendientes_sync` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios_sync`
--

DROP TABLE IF EXISTS `usuarios_sync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_sync` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `nuevo_nombre` varchar(50) DEFAULT NULL,
  `public_key` text,
  `creado_en` enum('linux','windows') NOT NULL,
  `fecha_creado` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `linux_estado` enum('pendiente','ok','error') NOT NULL DEFAULT 'pendiente',
  `linux_error` text,
  `windows_estado` enum('pendiente','ok','error') NOT NULL DEFAULT 'pendiente',
  `windows_error` text,
  `ultima_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ssh_key_pub` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_sync`
--

LOCK TABLES `usuarios_sync` WRITE;
/*!40000 ALTER TABLE `usuarios_sync` DISABLE KEYS */;
INSERT INTO `usuarios_sync` VALUES (1,'angelg','Greenday56',NULL,NULL,'linux','2025-11-30 20:59:03','ok',NULL,'ok',NULL,'2025-12-08 02:55:53','ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsqLWk6hVxg28W/y/SUTtQyceUz1kRT0C60+wHKkPAFeoOOdOf5ndFCTm0GROfCrzQ88rvx091tRU2iRbHfCxWGKbnOauwddaeZyisyBimCMQGobzcC5ulREZ0vr7cH6T4HTbH1JW0pjewOODDi43j6aFcRwNSpgWc+/aErjxWtUWL45PObh0FReV8oM8C5PZUIDdu7Qo604PazM8pZkr6fI6cNxfHd7YMQasu7egtOc0cHySo0ahLnGYC8s7DwfcYQmCqWgu2RlBKoYacDrXF703e0jVK+eAff3szLsv32ICSFxZ+vI7DGWiH2M5MaoPqlWS+k3HpL48HQNmCx8Gf administrador@WIN-2JQMPC9B9O5'),(2,'testuser','12345',NULL,NULL,'linux','2025-11-30 21:02:13','ok',NULL,'ok',NULL,'2025-12-08 01:56:42',NULL),(4,'testuser1','12345',NULL,NULL,'linux','2025-11-30 21:03:18','ok',NULL,'pendiente',NULL,'2025-11-30 21:03:18',NULL),(5,'otrotest','5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5',NULL,NULL,'linux','2025-11-30 21:05:53','ok',NULL,'ok',NULL,'2025-12-01 00:45:33',NULL),(6,'otrotest1','12345',NULL,NULL,'linux','2025-11-30 21:09:02','ok',NULL,'pendiente',NULL,'2025-11-30 22:14:45',NULL),(8,'otrotest2','12345',NULL,NULL,'linux','2025-11-30 22:15:00','ok',NULL,'pendiente',NULL,'2025-11-30 22:15:00',NULL),(10,'angelg22','Greenday56',NULL,NULL,'windows','2025-12-01 00:42:25','ok',NULL,'ok',NULL,'2025-12-01 00:44:44',NULL),(15,'angelgPrueba','Greenday56',NULL,NULL,'linux','2025-12-03 19:36:30','ok',NULL,'pendiente',NULL,'2025-12-03 19:36:30',NULL),(19,'angelSincronizacion','123456789',NULL,NULL,'linux','2025-12-03 20:08:25','ok',NULL,'pendiente',NULL,'2025-12-03 20:08:25',NULL),(20,'angelSincronizacion1','123456789',NULL,NULL,'linux','2025-12-03 20:09:23','ok',NULL,'pendiente',NULL,'2025-12-03 20:09:23',NULL),(21,'angelSincronizacion2','123456789',NULL,NULL,'linux','2025-12-03 20:12:39','ok',NULL,'pendiente',NULL,'2025-12-03 20:12:39',NULL),(22,'angelSincronizacion3','123456789',NULL,NULL,'linux','2025-12-03 20:16:20','ok',NULL,'pendiente',NULL,'2025-12-03 20:16:20',NULL),(23,'angelSincronizacion4','123456789',NULL,NULL,'linux','2025-12-03 20:17:06','ok',NULL,'pendiente',NULL,'2025-12-03 20:17:06',NULL),(24,'angelSincronizacion5','123456789',NULL,NULL,'linux','2025-12-03 20:17:30','ok',NULL,'pendiente',NULL,'2025-12-03 20:17:30',NULL),(25,'angelSincronizacion6','123456789',NULL,NULL,'linux','2025-12-03 20:20:51','ok',NULL,'pendiente',NULL,'2025-12-03 20:20:51',NULL),(26,'angelSincronizacion7','123456789',NULL,NULL,'linux','2025-12-04 20:21:49','ok',NULL,'pendiente',NULL,'2025-12-04 20:21:49',NULL),(27,'Sincronizacion10','15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225',NULL,NULL,'windows','2025-12-04 20:26:14','ok',NULL,'ok',NULL,'2025-12-04 20:47:56',NULL),(30,'pruebac','12345789',NULL,NULL,'windows','2025-12-04 20:32:00','ok',NULL,'ok',NULL,'2025-12-04 20:47:57',NULL),(33,'angel123','123456789',NULL,NULL,'windows','2025-12-04 20:37:47','ok',NULL,'ok',NULL,'2025-12-04 20:47:57',NULL),(35,'angelg789','123456789',NULL,NULL,'windows','2025-12-04 20:40:27','ok',NULL,'ok',NULL,'2025-12-04 20:47:57',NULL),(36,'angelgPruebaB','123456789',NULL,NULL,'windows','2025-12-04 20:54:34','ok',NULL,'ok',NULL,'2025-12-04 20:54:49',NULL),(37,'angelgPruebaw','123456789',NULL,NULL,'linux','2025-12-04 20:55:46','ok',NULL,'ok',NULL,'2025-12-04 21:09:19',NULL),(38,'angelgPruebaL','123456789',NULL,NULL,'windows','2025-12-04 21:01:07','ok',NULL,'ok',NULL,'2025-12-04 21:05:10',NULL),(39,'OtroUsuarioPrueba','123456789',NULL,NULL,'windows','2025-12-04 21:03:51','ok',NULL,'ok',NULL,'2025-12-04 21:05:14',''),(41,'OtroUsuarioPrueba1','123456789',NULL,NULL,'windows','2025-12-04 21:05:02','ok',NULL,'ok',NULL,'2025-12-04 21:05:18',''),(42,'testLinux','123456798',NULL,NULL,'linux','2025-12-04 21:06:22','ok',NULL,'ok',NULL,'2025-12-04 21:09:21',NULL),(44,'testLinux3','123456798',NULL,NULL,'linux','2025-12-04 21:08:48','ok',NULL,'ok',NULL,'2025-12-04 21:09:22',NULL),(45,'testLinux4','123456798',NULL,NULL,'linux','2025-12-04 21:22:29','ok',NULL,'ok',NULL,'2025-12-04 21:26:47',NULL),(46,'angelg90','Greenday56',NULL,NULL,'linux','2025-12-04 21:39:48','ok',NULL,'ok',NULL,'2025-12-08 02:44:38',''),(47,'angelg99','123456',NULL,NULL,'linux','2025-12-04 21:52:36','ok',NULL,'ok',NULL,'2025-12-04 21:53:12',NULL),(48,'angel100','123465',NULL,NULL,'windows','2025-12-04 22:22:20','ok',NULL,'ok',NULL,'2025-12-05 01:10:30',''),(49,'teUsuario','123456789',NULL,NULL,'linux','2025-12-05 01:05:02','ok',NULL,'ok',NULL,'2025-12-05 01:56:13',''),(51,'teUsuario2','123456789',NULL,NULL,'windows','2025-12-05 01:15:23','ok',NULL,'ok',NULL,'2025-12-05 02:33:59',''),(52,'usuarioModi','0604bd1ee3675160e4533a272305a82ddd3f91466c0d3f045ceadfbd98b384f6',NULL,NULL,'linux','2025-12-05 01:55:49','ok',NULL,'error','Usuario no existe','2025-12-05 03:19:19',NULL),(53,'modi','0604bd1ee3675160e4533a272305a82ddd3f91466c0d3f045ceadfbd98b384f6',NULL,NULL,'linux','2025-12-05 02:00:52','ok',NULL,'error','Usuario no existe','2025-12-05 03:19:20',NULL),(54,'mod','159852',NULL,NULL,'linux','2025-12-05 02:09:34','ok',NULL,'ok',NULL,'2025-12-05 02:33:59',''),(56,'testmod30','123456',NULL,NULL,'linux','2025-12-05 02:19:34','ok',NULL,'error','Usuario no existe','2025-12-05 03:19:20',NULL),(57,'lol','123456',NULL,NULL,'linux','2025-12-05 02:25:56','ok',NULL,'error','Usuario no existe','2025-12-05 03:19:21',NULL),(58,'renombrar','12346',NULL,NULL,'windows','2025-12-05 02:33:25','ok',NULL,'ok',NULL,'2025-12-05 02:34:29',''),(59,'angelg21','123456',NULL,NULL,'linux','2025-12-05 02:50:16','ok',NULL,'error','Usuario no existe','2025-12-05 03:19:21',NULL),(60,'ang','123456',NULL,NULL,'linux','2025-12-05 03:32:19','ok',NULL,'ok',NULL,'2025-12-05 03:32:28',NULL),(61,'angelw','12345678',NULL,NULL,'windows','2025-12-05 04:08:01','pendiente',NULL,'ok',NULL,'2025-12-05 04:08:01',''),(62,'angelq','12345678',NULL,NULL,'windows','2025-12-05 04:19:50','ok',NULL,'ok',NULL,'2025-12-05 04:32:28',''),(63,'angelqq','12345678',NULL,NULL,'windows','2025-12-05 04:32:07','ok',NULL,'ok',NULL,'2025-12-05 04:41:22',''),(64,'angelqqs','12345678',NULL,NULL,'windows','2025-12-05 04:41:44','ok',NULL,'ok',NULL,'2025-12-05 04:44:33',''),(65,'angelggg','12345678',NULL,NULL,'linux','2025-12-05 04:43:33','ok',NULL,'ok',NULL,'2025-12-08 01:50:32',NULL),(66,'angelg65','Greenday56',NULL,NULL,'linux','2025-12-08 01:49:36','ok',NULL,'ok',NULL,'2025-12-08 01:50:33',NULL),(69,'190292','Greenday56',NULL,NULL,'windows','2025-12-08 03:00:46','pendiente',NULL,'ok',NULL,'2025-12-08 03:00:46',''),(70,'slkfkljsdf','Greenday56',NULL,NULL,'windows','2025-12-08 03:01:55','pendiente',NULL,'ok',NULL,'2025-12-08 03:01:55','');
/*!40000 ALTER TABLE `usuarios_sync` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_usuario_creado` AFTER INSERT ON `usuarios_sync` FOR EACH ROW BEGIN
    
    INSERT INTO eventos_sync (username, accion, origen, detalle)
    VALUES (NEW.username, 'CREADO', NEW.creado_en, 'Usuario creado en sistema origen');

    
    IF NOT EXISTS (
        SELECT 1 FROM pendientes_sync
        WHERE username = NEW.username
        AND accion = 'CREAR'
        AND destino = IF(NEW.creado_en = 'windows', 'LINUX', 'WINDOWS')
        AND procesado = 0
    ) THEN
        INSERT INTO pendientes_sync (username, accion, destino)
        VALUES (
            NEW.username,
            'CREAR',
            IF(NEW.creado_en = 'windows', 'LINUX', 'WINDOWS')
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_usuario_modificado` AFTER UPDATE ON `usuarios_sync` FOR EACH ROW BEGIN
    INSERT INTO eventos_sync (username, accion, origen, detalle)
    VALUES (NEW.username, 'MODIFICADO', NEW.creado_en, 'Usuario modificado');

    
    IF NOT EXISTS (
        SELECT 1 FROM pendientes_sync
        WHERE username = NEW.username
        AND accion = 'MODIFICAR'
        AND destino = IF(NEW.creado_en = 'windows', 'LINUX', 'WINDOWS')
        AND procesado = 0
    ) THEN
        INSERT INTO pendientes_sync (username, accion, destino)
        VALUES (
            NEW.username,
            'MODIFICAR',
            IF(NEW.creado_en = 'windows', 'LINUX', 'WINDOWS')
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_usuario_eliminado` AFTER DELETE ON `usuarios_sync` FOR EACH ROW BEGIN
    INSERT INTO eventos_sync (username, accion, origen, detalle)
    VALUES (OLD.username, 'ELIMINADO', OLD.creado_en, 'Usuario eliminado');

    IF NOT EXISTS (
        SELECT 1 FROM pendientes_sync
        WHERE username = OLD.username
        AND accion = 'ELIMINAR'
        AND destino = IF(OLD.creado_en = 'windows', 'LINUX', 'WINDOWS')
        AND procesado = 0
    ) THEN
        INSERT INTO pendientes_sync (username, accion, destino)
        VALUES (
            OLD.username,
            'ELIMINAR',
            IF(OLD.creado_en = 'windows', 'LINUX', 'WINDOWS')
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'Proyecto'
--

--
-- Dumping routines for database 'Proyecto'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-08 17:43:23
