-- Trigger AFTER INSERT para Auditoría de Salarios

CREATE TRIGGER after_insert_salario
AFTER INSERT ON salarios
FOR EACH ROW
BEGIN
INSERT INTO auditoria_salarios (empleado_id, salario_anterior, nuevo_salario) VALUES (NEW.empleado_id, 0.00, NEW.salario);
END;

-- Trigger BEFORE UPDATE para Validar Aumento de Salario

CREATE TRIGGER before_update_salario
BEFORE UPDATE ON salarios
FOR EACH ROW
BEGIN
    IF NEW.salario<OLD.salario THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error:  El nuevo salario debe ser mayor al anterior';
    END IF;
END;

-- Trigger AFTER UPDATE para Registrar Cambios en el Salario

CREATE TRIGGER after_update_salario
AFTER UPDATE ON salarios
FOR EACH ROW
BEGIN
    IF NEW.salario <> OLD.salario THEN
        INSERT INTO auditoria_salarios (empleado_id, salario_anterior, nuevo_salario) VALUES (OLD.empleado_id, OLD.salario, NEW.salario);
    END IF;
END;

-- Trigger AFTER DELETE para Manejar la Eliminación de Salarios

CREATE TRIGGER after_delete_salario
AFTER DELETE ON salarios
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_salarios (empleado_id, salario_anterior, nuevo_salario) VALUES (OLD.empleado_id, OLD.salario, 0.00);
END;

-- Reporte de Auditoría Completo
/* consulta para mostrar un informe de auditoría de cambios en los salarios, incluyendo el
nombre del empleado, el salario anterior, el nuevo salario, y la fecha de cada cambio. */

SELECT empleados.nombre as Nombre, auditoria_salarios.salario_anterior as SalarioAnterior, auditoria_salarios.nuevo_salario as NuevoSalario, auditoria_salarios.fecha_cambio as fecha_cambio
FROM empleados
INNER JOIN auditoria_salarios ON empleados.id = auditoria_salarios.empleado_id
ORDER BY fecha_cambio DESC;

SELECT empleados.nombre as Nombre, auditoria_salarios.salario_anterior as SalarioAnterior, auditoria_salarios.nuevo_salario as NuevoSalario, auditoria_salarios.fecha_cambio as fecha_cambio
FROM auditoria_salarios
INNER JOIN empleados ON auditoria_salarios.empleado_id = empleados.id
ORDER BY fecha_cambio DESC;