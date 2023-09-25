
<!-- README.md is generated from README.Rmd. Please edit that file -->

# resios

<!-- badges: start -->

[![R-CMD-check](https://github.com/llrs/resios/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/llrs/resios/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of resios is to provide an easy way to interact with the ESIOS
API.

## Installation

You can install the development version of resios from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("llrs/resios")
```

# Status

This packages includes the minimal functions to make it usable for me.
If anyone want to query some other data and the parser do not work well,
open an issue and I’ll try to fix it.

## Examples

We need to load the library and prepare the token for the session. See
the `get_token()` help page for information about how to do that.

``` r
library("resios")
get_token()
```

Once ready we can look for some indicators (also to check that our token
works):

``` r
ei <- esios_search_indicators()
head(ei)
#>                                                                  name
#> 1                            Generación programada PBF Hidráulica UGH
#> 2                         Generación programada PBF Hidráulica no UGH
#> 3                        Generación programada PBF Turbinación bombeo
#> 4                                   Generación programada PBF Nuclear
#> 5      Generación programada PBF Hulla antracita Anexo II RD 134/2010
#> 6 Generación programada PBF Hulla sub-bituminosa Anexo II RD 134/2010
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                description
#> 1                            <p>Es el programa de energía diario, con desglose horario, de las diferentes Unidades de Programación correspondientes a ventas y adquisiciones de energía en el sistema eléctrico peninsular español. En concreto este indicador se refiere a las unidades de programación con tipo de producción hidráulica UGH.</p><p>Este programa es establecido por el OS a partir de la casación del OM y de las nominaciones de programas de todas y cada una de las Unidades de Programación que le han sido comunicadas por los sujetos titulares de dichas Unidades de Programación, incluyendo las correspondientes a la ejecución de contratos bilaterales con entrega física de los cuales se ha confirmado la ejecución.</p><p><b>Publicación:</b> diariamente a partir de las 13:45 horas con la información del día D+1.</p>
#> 2                         <p>Es el programa de energía diario, con desglose horario, de las diferentes Unidades de Programación correspondientes a ventas y adquisiciones de energía en el sistema eléctrico peninsular español. En concreto este indicador se refiere a las unidades de programación con tipo de producción hidráulica no UGH.</p><p>Este programa es establecido por el OS a partir de la casación del OM y de las nominaciones de programas de todas y cada una de las Unidades de Programación que le han sido comunicadas por los sujetos titulares de dichas Unidades de Programación, incluyendo las correspondientes a la ejecución de contratos bilaterales con entrega física de los cuales se ha confirmado la ejecución.</p><p><b>Publicación:</b> diariamente a partir de las 13:45 horas con la información del día D+1.</p>
#> 3                        <p>Es el programa de energía diario, con desglose horario, de las diferentes Unidades de Programación correspondientes a ventas y adquisiciones de energía en el sistema eléctrico peninsular español. En concreto este indicador se refiere a las unidades de programación con tipo de producción turbinación bombeo.</p><p>Este programa es establecido por el OS a partir de la casación del OM y de las nominaciones de programas de todas y cada una de las Unidades de Programación que le han sido comunicadas por los sujetos titulares de dichas Unidades de Programación, incluyendo las correspondientes a la ejecución de contratos bilaterales con entrega física de los cuales se ha confirmado la ejecución.</p><p><b>Publicación:</b> diariamente a partir de las 13:45 horas con la información del día D+1.</p>
#> 4                                   <p>Es el programa de energía diario, con desglose horario, de las diferentes Unidades de Programación correspondientes a ventas y adquisiciones de energía en el sistema eléctrico peninsular español. En concreto este indicador se refiere a las unidades de programación con tipo de producción nuclear.</p><p>Este programa es establecido por el OS a partir de la casación del OM y de las nominaciones de programas de todas y cada una de las Unidades de Programación que le han sido comunicadas por los sujetos titulares de dichas Unidades de Programación, incluyendo las correspondientes a la ejecución de contratos bilaterales con entrega física de los cuales se ha confirmado la ejecución.</p><p><b>Publicación:</b> diariamente a partir de las 13:45 horas con la información del día D+1.</p>
#> 5      <p>Es el programa de energía diario, con desglose horario, de las diferentes Unidades de Programación correspondientes a ventas y adquisiciones de energía en el sistema eléctrico peninsular español. En concreto este indicador se refiere a las unidades de programación con tipo de producción Hulla antracita Anexo II RD 134/2010.</p><p>Este programa es establecido por el OS a partir de la casación del OM y de las nominaciones de programas de todas y cada una de las Unidades de Programación que le han sido comunicadas por los sujetos titulares de dichas Unidades de Programación, incluyendo las correspondientes a la ejecución de contratos bilaterales con entrega física de los cuales se ha confirmado la ejecución.</p><p><b>Publicación:</b> diariamente a partir de las 13:45 horas con la información del día D+1.</p>
#> 6 <p>Es el programa de energía diario, con desglose horario, de las diferentes Unidades de Programación correspondientes a ventas y adquisiciones de energía en el sistema eléctrico peninsular español. En concreto este indicador se refiere a las unidades de programación con tipo de producción Hulla sub-bituminosa Anexo II RD 134/2010.</p><p>Este programa es establecido por el OS a partir de la casación del OM y de las nominaciones de programas de todas y cada una de las Unidades de Programación que le han sido comunicadas por los sujetos titulares de dichas Unidades de Programación, incluyendo las correspondientes a la ejecución de contratos bilaterales con entrega física de los cuales se ha confirmado la ejecución.</p><p><b>Publicación:</b> diariamente a partir de las 13:45 horas con la información del día D+1.</p>
#>                         short_name id renew
#> 1                   Hidráulica UGH  1 13:45
#> 2                Hidráulica no UGH  2 13:45
#> 3               Turbinación bombeo  3 13:45
#> 4                          Nuclear  4 13:45
#> 5      Hulla antracita RD 134/2010  5 13:45
#> 6 Hulla sub-bituminosa RD 134/2010  6 13:45
```

There are many indicators (1908) and as you can see some are updated
quite frequently daily. Others the date is unclear and you should read
the last sentence of the description.

The one probably more interesting is the price of electricity in the
state contract (updated each day at 20:20). There is a direct function
for that one:

``` r
ei[ei$id == "1001", -2]
#>                                                        name    short_name   id
#> 913 Término de facturación de energía activa del PVPC 2.0TD PVPC T. 2.0TD 1001
#>     renew
#> 913 20:20
head(esios_pvpc())
#> Waiting 4s for throttling delay ■■■■■■■■
#> Waiting 4s for throttling delay ■■■■■■■■■■■
#> Waiting 4s for throttling delay ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
#>    value            datetime        datetime_utc             tz_time geo_id
#> 1 166.33 2023-09-25 00:00:00 2023-09-24 22:00:00 2023-09-24 22:00:00   8741
#> 2 166.33 2023-09-25 00:00:00 2023-09-24 22:00:00 2023-09-24 22:00:00   8742
#> 3 166.33 2023-09-25 00:00:00 2023-09-24 22:00:00 2023-09-24 22:00:00   8743
#> 4 166.33 2023-09-25 00:00:00 2023-09-24 22:00:00 2023-09-24 22:00:00   8744
#> 5 166.33 2023-09-25 00:00:00 2023-09-24 22:00:00 2023-09-24 22:00:00   8745
#> 6 153.60 2023-09-25 01:00:00 2023-09-24 23:00:00 2023-09-24 23:00:00   8741
#>    geo_name
#> 1 Península
#> 2  Canarias
#> 3  Baleares
#> 4     Ceuta
#> 5   Melilla
#> 6 Península
```

You can filter and plot it.

## REE

You can also query the Red Eléctrica Española directly (it doesn’t
require to get a token):

``` r
rc0 <- ree_call(widget = "demanda-tiempo-real", category = "demanda")
#> Last updated: 2023-09-25 00:00:00
plot(rc0$`Demanda real`$datetime, rc0$`Demanda real`$value, type = "l", pch = 2,
     main = "Electricity demand in peninsular Spain", 
     xlab = "Time", ylab = "Value (?)")
lines(rc0$`Demanda programada`$datetime, rc0$`Demanda programada`$value, 
      type = "l", col = "blue", lty = 2)
lines(rc0$`Demanda prevista`$datetime, rc0$`Demanda prevista`$value, 
      type = "l", col = "red", lty = 3)
abline(h = Sys.time(), col = "black")
legend("topleft", legend = c("real", "foreseen", "programmed"), 
       fill = c("black", "red", "blue"))
```

<img src="man/figures/README-ree-1.png" width="100%" />
