CREATE OR REPLACE FUNCTION public.servicio_registrar_datos(
    _i_nombre_facturacion CHARACTER VARYING,
    _i_ci_nit CHARACTER VARYING,
    _i_ciudad CHARACTER VARYING,
    _i_urbano_rural CHARACTER VARYING,
    _i_depto CHARACTER VARYING,
    _i_depto_id INTEGER,
    _i_depto_descr CHARACTER VARYING,
    _i_municipio CHARACTER VARYING,
    _i_municipio_id_depto INTEGER,
    _i_municipio_descr CHARACTER VARYING,
    _i_municipio_id_provincia INTEGER,
    _i_municipio_id_alcaldia INTEGER,
    _i_municipio_dpa CHARACTER VARYING,
    _i_dpa CHARACTER VARYING,
    _i_zonauv CHARACTER VARYING,
    _i_zonauv_codigo_zona CHARACTER VARYING,
    _i_zonauv_descr CHARACTER VARYING,
    _i_zonauv_cod_adm CHARACTER VARYING,
    _i_marker CHARACTER VARYING,
    _i_marker_id INTEGER,
    _i_marker_position CHARACTER VARYING,
    _i_marker_lat CHARACTER VARYING,
    _i_marker_long CHARACTER VARYING,
    _i_marker_visible CHARACTER VARYING,
    _i_marker_visible2 CHARACTER VARYING,
    _i_marker_drag CHARACTER VARYING,
    _i_zona_barrio_uv_otro CHARACTER VARYING,
    _i_calle_avenida CHARACTER VARYING,
    _i_dir_referencial CHARACTER VARYING,
    _i_numero CHARACTER VARYING,
    _i_edificio CHARACTER VARYING,
    _i_piso CHARACTER VARYING,
    _i_departamento_local_oficina CHARACTER VARYING,
    _i_longitud CHARACTER VARYING,
    _i_latitud CHARACTER VARYING,
    _i_usuario INTEGER,
    _i_zona_codigo_zona_completo CHARACTER VARYING
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
    municipio_pk INTEGER;
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
        VALUES($36, CURRENT_TIMESTAMP, $15, $37, $16, $17, $18, municipio_pk)
        RETURNING id INTO zona_pk;
    ELSE
        SELECT id FROM direccion_zona WHERE zonauv_codigo_zona=$16
        INTO zona_pk;
    END IF;

    IF (SELECT COUNT(*) FROM direccion_marker WHERE marker_id=$20::CHARACTER VARYING)=0 THEN
        INSERT INTO direccion_marker(usuario_creacion, fecha_creacion, marker, marker_id, marker_position, marker_lat, marker_long, marker_visible, marker_visible2, marker_drag, zona_id)
        VALUES($36, CURRENT_TIMESTAMP, $19, $20::CHARACTER VARYING, $21, $22, $23, $24, $25, $26, zona_pk)
        RETURNING id INTO marker_pk;
    ELSE
        SELECT id FROM direccion_marker WHERE marker_id=$20::CHARACTER VARYING
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
