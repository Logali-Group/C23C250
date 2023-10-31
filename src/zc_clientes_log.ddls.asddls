@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Clientes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity zc_clientes_log
  as select from ztclientes_log as Clientes
    inner join   ztclnt_lib_log as ClientesLib on Clientes.id_cliente = ClientesLib.id_cliente
{
  key ClientesLib.id_libro                                      as IdLibro,
  key Clientes.id_cliente                                       as IdCliente,
  key Clientes.tipo_acceso                                      as Acceso,
      Clientes.nombre                                           as Nombre,
      Clientes.apellidos                                        as Apellidos,
      Clientes.email                                            as Email,
      Clientes.url                                              as Imagen,
      concat_with_space(Clientes.nombre, Clientes.apellidos, 1) as NombreCompleto
}
