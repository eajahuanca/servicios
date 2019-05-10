CREATE OR REPLACE FUNCTION public.servicio_registrar_datos(
    nombre_facturacion CHARACTER VARYING,
    ci_nit CHARACTER VARYING,
    ciudad CHARACTER VARYING,
    urbano_rural CHARACTER VARYING,
    depto CHARACTER VARYING,
    depto_id INTEGER,
    depto_descr CHARACTER VARYING,
    municipio CHARACTER VARYING,
    municipio_id_depto INTEGER,
    municipio_descr CHARACTER VARYING,
    municipio_id_provincia INTEGER,
    municipio_id_alcaldia INTEGER,
    municipio_dpa CHARACTER VARYING,
    dpa CHARACTER VARYING,
    zonauv CHARACTER VARYING,
    zonauv_codigo_zona CHARACTER VARYING,
    zonauv_descr CHARACTER VARYING,
    zonauv_cod_adm CHARACTER VARYING,
    marker CHARACTER VARYING,
    marker_id INTEGER,
    marker_position CHARACTER VARYING,
    marker_lat CHARACTER VARYING,
    marker_long CHARACTER VARYING,
    marker_visible CHARACTER VARYING,
    marker_visible2 CHARACTER VARYING,
    marker_drag CHARACTER VARYING,
    zona_barrio_uv_otro CHARACTER VARYING,
    calle_avenida CHARACTER VARYING,
    dir_referencial CHARACTER VARYING,
    numero CHARACTER VARYING,
    edificio CHARACTER VARYING,
    piso CHARACTER VARYING,
    departamento_local_oficina CHARACTER VARYING,
    longitud CHARACTER VARYING,
    latitud CHARACTER VARYING,
    usuario INTEGER
)
RETURNS response AS
$BODY$
/**
* Funcion: servicio_registrar_datos
* Author: Edwin Ajahuanca C.
* Descripcion: Esta funcion registra los datos enviados como: 
               departamentos, provincia, muncipio, zona, alcaldia, ubicacion(marker)
*
 */
DECLARE
    response RESPONSE;
    departamento_pk INTEGER;
    provincia_pk INTEGER;
    alcaldia_pk INTEGER;
    muncipio_pk INTEGER;
    zona_pk INTEGER;
    marker_pk INTEGER;
    servicio_pk INTEGER;
BEGIN
    response.type := 'S';
    response.message := 'Registro realizado con exito';

    IF (SELECT COUNT(*) FROM direccion_departamento WHERE departamento=$5 AND id=$6)=0 THEN
        INSERT INTO direccion_departamento(usuario_creacion, fecha_creacion, id, departamento, departamento_descripcion)
        VALUES($36, CURRENT_TIMESTAMP, $6, $5, $7);
    ELSE
        SELECT id FROM direccion_departamento WHERE departamento=$5 AND id=$6
        INTO departamento_pk;
    END IF;

    IF (SELECT COUNT(*) FROM direccion_provincia WHERE id=$11)=0 THEN
        INSERT INTO direccion_provincia(usuario_creacion, fecha_creacion, id, provincia, provincia_descripcion, departamento_id)
        VALUES($36, CURRENT_TIMESTAMP, $11, 'S/P','S/D', $6);
    ELSE
        SELECT id FROM direccion_provincia WHERE id=$11
        INTO provincia_pk;
    END IF;

    IF (SELECT COUNT(*) FROM direccion_alcaldia WHERE id=$12)=0 THEN
        INSERT INTO direccion_alcaldia(usuario_creacion, fecha_creacion, id, alcaldia, sigla, dpa)
        VALUES($36, CURRENT_TIMESTAMP, $12, 'S/N', 'S/S', $14);
    ELSE
        SELECT id FROM direccion_alcaldia WHERE id=$12
        INTO alcaldia_pk;
    END IF;

    IF (SELECT COUNT(*) FROM direccion_municipio WHERE municipio=$8)=0 THEN
        INSERT INTO direccion_municipio(usuario_creacion, fecha_creacion, municipio, municipio_descripcion, alcaldia_id, provincia_id)
        VALUES($36, CURRENT_TIMESTAMP, $8, $10, $12, $11)
        RETURNING id INTO municipio_pk;
    ELSE
        SELECT id FROM direccion_municipio WHERE municipio=$8
        INTO municipio_pk;
    END IF;

    IF (SELECT COUNT(*) FROM direccion_zona WHERE zonauv_codigo_zona=$16)=0 THEN
        INSERT INTO direccion_zona(usuario_creacion, fecha_creacion, zonauv, zonauv_codigo_zona_completo, zonauv_codigo_zona, zonauv_descr, zonauv_cod_adm, municipio_id)
        VALUES($36, CURRENT_TIMESTAMP, $15, $16, $16, $17, $18, municipio_pk)
        RETURNING id INTO zona_pk;
    ELSE
        SELECT id FROM direccion_zona WHERE zonauv_codigo_zona=$16
        INTO zona_pk;
    END IF;

    IF (SELECT COUNT(*) FROM direccion_marker WHERE marker_id=$20)=0 THEN
        INSERT INTO direccion_marker(usuario_creacion, fecha_creacion, marker, marker_id, marker_position, marker_lat, marker_long, marker_visible, marker_visible2, marker_drag, zona_id)
        VALUES($36, CURRENT_TIMESTAMP, $19, $20, $21, $22, $23, $24, $25, $26, zona_pk)
        RETURNING id INTO marker_pk;
    ELSE
        SELECT id FROM direccion_marker WHERE marker_id=$20
        INTO marker_pk;
    END IF;

    INSERT INTO servicio_servicio(usuario_creacion, fecha_creacion, nombre_facturacion, ci_nit, ciudad, urbano_rural, departamento_id, marker_id, municipio_id, provincia_id, zona_id)
    VALUES($36, CURRENT_TIMESTAMP, $1, $2, $3, $4, departamento_pk, marker_pk, municipio_pk, provincia_pk, zona_pk)
    RETURNING id INTO servicio_pk;

    INSERT INTO direccion_direccion(usuario_creacion, fecha_creacion, zona_barrio_uv_otro, calle_avenida, dir_referencial, numero, edificio, piso, departamento_local_oficina, longitud, latitud, servicio_id)
    VALUES($36, CURRENT_TIMESTAMP, $27, $28, $29, $30, $31, $32, $33, $34, $35, servicio_pk);

    RETURN response;
    
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
