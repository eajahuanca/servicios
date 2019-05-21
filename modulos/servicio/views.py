from datetime import datetime as dt
from django.http import HttpResponse
from rest_framework import status, viewsets
from rest_framework.decorators import api_view, action
from rest_framework.authtoken.models import Token
from rest_framework.permissions import (
    IsAuthenticated, 
    IsAuthenticatedOrReadOnly, 
    DjangoModelPermissions
)
from agbc_servicio.settings import TOKEN_SERVICIO
from rest_framework.response import Response
from agbc_servicio.response import (
    SuccessRestResponse,
    ErrorRestResponse
)
from modulos.parametro.db import (
    PgParameter, 
    DataBaseProcedure
)
from modulos.direccion.models import (
    Departamento,
    Provincia,
    Municipio,
    Alcaldia
)
from modulos.personal.models import (
    Profesion,
    Cargo,
    Oficina,
    Personal
)
from modulos.servicio.models import (
    Servicio
)
from modulos.seguridad.models import Usuario
from rest_framework.authentication import BaseAuthentication, get_authorization_header


class ServicioModelViewSet(viewsets.ViewSet):

    def create(self, request):
        """
        Funcion que se encarga de registrar los datos enviados por el
        metodo [POST] con referente al servicio.
        """
        auth = get_authorization_header(request).split()
        if auth:
            try:
                token = auth[1].decode()
                if token == TOKEN_SERVICIO:
                    nombre_facturacion = request.data['nombre_facturacion']
                    ci_nit = request.data['ci_nit']
                    ciudad = request.data['ciudad']
                    urbano_rural = request.data['urbano_rural']
                    depto = request.data['ubicacion']['depto']
                    depto_id = request.data['ubicacion']['depto_id']
                    depto_descr = request.data['ubicacion']['depto_descr']
                    municipio = request.data['ubicacion']['municipio']
                    municipio_id_depto = request.data['ubicacion']['municipio_id_depto']
                    municipio_descr = request.data['ubicacion']['municipio_descr']
                    municipio_id_provincia = request.data['ubicacion']['municipio_id_provincia']
                    municipio_id_alcaldia = request.data['ubicacion']['municipio_id_alcaldia']
                    municipio_dpa = request.data['ubicacion']['municipio_dpa']
                    dpa = request.data['ubicacion']['dpa']
                    zonauv = request.data['ubicacion']['zonauv']
                    zonauv_codigo_zona_completo = request.data['ubicacion']['zonauv_codigo_zona_completo']
                    zonauv_codigo_zona = request.data['ubicacion']['zonauv_codigo_zona']
                    zonauv_descr = request.data['ubicacion']['zonauv_descr']
                    zonauv_cod_adm = request.data['ubicacion']['zonauv_cod_adm']
                    marker = request.data['ubicacion']['marker']
                    marker_id = request.data['ubicacion']['marker_id']
                    marker_position = request.data['ubicacion']['marker_position']
                    marker_lat = request.data['ubicacion']['marker_lat']
                    marker_long = request.data['ubicacion']['marker_long']
                    marker_visible = request.data['ubicacion']['marker_visible']
                    marker_visible2 = request.data['ubicacion']['marker_visible2']
                    marker_drag = request.data['ubicacion']['marker_drag']
                    zona_barrio_uv_otro = request.data['ubicacion']['zona_barrio_uv_otro']
                    calle_avenida = request.data['ubicacion']['calle_avenida']
                    dir_referencial = request.data['ubicacion']['dir_referencial']
                    numero = request.data['ubicacion']['numero']
                    edificio = request.data['ubicacion']['edificio']
                    piso = request.data['ubicacion']['piso']
                    departamento_local_oficina = request.data['ubicacion']['departamento_local_oficina']
                    longitud = request.data['ubicacion']['longitud']
                    latitud = request.data['ubicacion']['latitud']
                    usuario = Token.objects.filter(key=token).first()
                    usuario_id = usuario.user_id

                    data = DataBaseProcedure('servicio_registrar_datos') \
                        .add_parameter(nombre_facturacion, PgParameter.PG_CHAR) \
                        .add_parameter(ci_nit, PgParameter.PG_CHAR) \
                        .add_parameter(ciudad, PgParameter.PG_CHAR) \
                        .add_parameter(urbano_rural, PgParameter.PG_CHAR) \
                        .add_parameter(depto, PgParameter.PG_CHAR) \
                        .add_parameter(int(depto_id), PgParameter.PG_INT) \
                        .add_parameter(depto_descr, PgParameter.PG_CHAR) \
                        .add_parameter(municipio, PgParameter.PG_CHAR) \
                        .add_parameter(int(municipio_id_depto), PgParameter.PG_INT) \
                        .add_parameter(municipio_descr, PgParameter.PG_CHAR) \
                        .add_parameter(int(municipio_id_provincia), PgParameter.PG_INT) \
                        .add_parameter(int(municipio_id_alcaldia), PgParameter.PG_INT) \
                        .add_parameter(municipio_dpa, PgParameter.PG_CHAR) \
                        .add_parameter(dpa, PgParameter.PG_CHAR) \
                        .add_parameter(zonauv, PgParameter.PG_CHAR) \
                        .add_parameter(zonauv_codigo_zona, PgParameter.PG_CHAR) \
                        .add_parameter(zonauv_descr, PgParameter.PG_CHAR) \
                        .add_parameter(zonauv_cod_adm, PgParameter.PG_CHAR) \
                        .add_parameter(marker, PgParameter.PG_CHAR) \
                        .add_parameter(int(marker_id), PgParameter.PG_INT) \
                        .add_parameter(marker_position, PgParameter.PG_CHAR) \
                        .add_parameter(marker_lat, PgParameter.PG_CHAR) \
                        .add_parameter(marker_long, PgParameter.PG_CHAR) \
                        .add_parameter(marker_visible, PgParameter.PG_CHAR) \
                        .add_parameter(marker_visible2, PgParameter.PG_CHAR) \
                        .add_parameter(marker_drag, PgParameter.PG_CHAR) \
                        .add_parameter(zona_barrio_uv_otro, PgParameter.PG_CHAR) \
                        .add_parameter(calle_avenida, PgParameter.PG_CHAR) \
                        .add_parameter(dir_referencial, PgParameter.PG_CHAR) \
                        .add_parameter(numero, PgParameter.PG_CHAR) \
                        .add_parameter(edificio, PgParameter.PG_CHAR) \
                        .add_parameter(piso, PgParameter.PG_CHAR) \
                        .add_parameter(departamento_local_oficina, PgParameter.PG_CHAR) \
                        .add_parameter(longitud, PgParameter.PG_CHAR) \
                        .add_parameter(latitud, PgParameter.PG_CHAR) \
                        .add_parameter(usuario_id, PgParameter.PG_INT) \
                        .add_parameter(zonauv_codigo_zona_completo, PgParameter.PG_CHAR)

                    return data.get_message().get_response()
                    #return SuccessRestResponse(
                    #    message='Registro exitoso',
                    #    status=status.HTTP_201_CREATED
                    #)
                else:
                    return ErrorRestResponse(
                        message='Token no valido',
                        status=status.HTTP_400_BAD_REQUEST
                    )
            except Exception as ex:    
                return ErrorRestResponse(
                    message='Ocurrio el siguiente error: %s' % ex,
                    status=status.HTTP_400_BAD_REQUEST
                )
        else:
            return ErrorRestResponse(
                message='Token requerido',
                status=status.HTTP_400_BAD_REQUEST
            )