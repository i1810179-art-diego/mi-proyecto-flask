-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 30-01-2026 a las 18:01:13
-- Versión del servidor: 8.0.31
-- Versión de PHP: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `flask_db`
--
CREATE DATABASE IF NOT EXISTS `flask_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `flask_db`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos`
--

DROP TABLE IF EXISTS `cursos`;
CREATE TABLE IF NOT EXISTS `cursos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `estado` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `cursos`
--

INSERT INTO `cursos` (`id`, `nombre`, `descripcion`, `estado`) VALUES
(1, 'Python Básico', 'Introducción a Python', 1),
(2, 'Desarrollo Web', 'HTML, CSS y Flask', 1),
(3, 'Bootstrap 5', 'framework css', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inscripciones`
--

DROP TABLE IF EXISTS `inscripciones`;
CREATE TABLE IF NOT EXISTS `inscripciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int DEFAULT NULL,
  `curso_id` int DEFAULT NULL,
  `fecha_inscripcion` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `curso_id` (`curso_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `inscripciones`
--

INSERT INTO `inscripciones` (`id`, `usuario_id`, `curso_id`, `fecha_inscripcion`) VALUES
(1, 1, 1, '2025-01-10'),
(2, 2, 2, '2025-01-15'),
(3, 3, 1, NULL),
(4, 3, 3, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`) VALUES
(1, 'Juan Pérez', 'juan@email.com'),
(2, 'María Lópeza', 'maria@email.com'),
(3, 'Andrea López', 'andrea@gmail.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios_sistema`
--

DROP TABLE IF EXISTS `usuarios_sistema`;
CREATE TABLE IF NOT EXISTS `usuarios_sistema` (
  `id` int NOT NULL AUTO_INCREMENT,
  `correo` varchar(100) DEFAULT NULL,
  `nombres` varchar(100) DEFAULT NULL,
  `apellidos` varchar(100) DEFAULT NULL,
  `clave` varchar(255) DEFAULT NULL,
  `rol` enum('administrador','asistente') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `usuarios_sistema`
--

INSERT INTO `usuarios_sistema` (`id`, `correo`, `nombres`, `apellidos`, `clave`, `rol`) VALUES
(1, 'admin@mail.com', 'Admin', 'Principal', '$2b$12$hqRk1fZehjC3ydzOOrgsQesiMF8taSk9QmJTzzL6NRvsC8w2qeBwq', 'administrador'),
(2, 'asistente@mail.com', 'Ana', 'Asistente', '$2b$12$L8.JJ10jMts6igBjBJcGyOVhGAzh0tTPrEdklWQuAHwYw5W0U9q3m', 'asistente');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
