CREATE DATABASE IF NOT EXISTS empresa;
USE empresa;
-- Tabla de empleados
CREATE TABLE empleados (
id INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(50) NOT NULL,
posicion VARCHAR(50),
fecha_contratacion DATE
);
-- Tabla de salarios
CREATE TABLE salarios (
id INT PRIMARY KEY AUTO_INCREMENT,
empleado_id INT,
salario DECIMAL(10, 2) NOT NULL,
fecha_ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);
-- Tabla de auditoría de cambios en salarios
CREATE TABLE auditoria_salarios (
id INT PRIMARY KEY AUTO_INCREMENT,
empleado_id INT,
salario_anterior DECIMAL(10, 2),
nuevo_salario DECIMAL(10, 2),
fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);