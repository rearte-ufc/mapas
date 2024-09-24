<?php
return [
    "module.registrationFieldTypes" => [
        "bank_types" => [
// Atualizado conforme listagem de instituições participantes do Sistema de Liquidação de Reservas (STR).
// Fonte........: Banco Central do Brasil (BCB).
// Disponível em: <https://www.bcb.gov.br/content/estabilidadefinanceira/str1/ParticipantesSTR.pdf>.
// Atualizado em: 24/09/2024.
            '644' => \MapasCulturais\i::__("644 - 321 SCD S.A."),
            '406' => \MapasCulturais\i::__("406 - ACCREDITO SCD S.A."),
            '332' => \MapasCulturais\i::__("332 - ACESSO SOLUÇÕES DE PAGAMENTO S.A. - INSTITUIÇÃO DE PAGAMENTO"),
            '117' => \MapasCulturais\i::__("117 - ADVANCED CC LTDA"),
            '577' => \MapasCulturais\i::__("577 - AF DESENVOLVE SP S.A."),
            '272' => \MapasCulturais\i::__("272 - AGK CC S.A."),
            '565' => \MapasCulturais\i::__("565 - ÁGORA CTVM S.A."),
            '599' => \MapasCulturais\i::__("599 - AGORACRED S/A SCFI"),
            '349' => \MapasCulturais\i::__("349 - AL5 S.A. CFI"),
            '572' => \MapasCulturais\i::__("572 - ALL IN CRED SCD S.A."),
            '594' => \MapasCulturais\i::__("594 - ASA SOCIEDADE DE CRÉDITO DIRETO S.A."),
            '461' => \MapasCulturais\i::__("461 - ASAAS IP S.A."),
            '513' => \MapasCulturais\i::__("513 - ATF SCD S.A."),
            '527' => \MapasCulturais\i::__("527 - ATICCA SCD S.A."),
            '188' => \MapasCulturais\i::__("188 - ATIVA S.A. INVESTIMENTOS CCTVM"),
            '508' => \MapasCulturais\i::__("508 - AVENUE SECURITIES DTVM LTDA."),
            '562' => \MapasCulturais\i::__("562 - AZIMUT BRASIL DTVM LTDA"),
            '463' => \MapasCulturais\i::__("463 - AZUMI DTVM"),
            '80' => \MapasCulturais\i::__("080 - B&T CC LTDA."),
            '75' => \MapasCulturais\i::__("075 - BANCO ABN AMRO CLEARING S.A."),
            '330' => \MapasCulturais\i::__("330 - BANCO BARI S.A."),
            '334' => \MapasCulturais\i::__("334 - BANCO BESA S.A."),
            '250' => \MapasCulturais\i::__("250 - BANCO BMG CONSIGNADO S.A."),
            '63' => \MapasCulturais\i::__("063 - BANCO BRADESCARD"),
            '208' => \MapasCulturais\i::__("208 - BANCO BTG PACTUAL S.A."),
            '233' => \MapasCulturais\i::__("233 - BANCO CIFRA"),
            '335' => \MapasCulturais\i::__("335 - BANCO DIGIO"),
            '94' => \MapasCulturais\i::__("094 - BANCO FINAXIS"),
            '125' => \MapasCulturais\i::__("125 - BANCO GENIAL"),
            '12' => \MapasCulturais\i::__("012 - BANCO INBURSA"),
            '77' => \MapasCulturais\i::__("077 - BANCO INTER"),
            '249' => \MapasCulturais\i::__("249 - BANCO INVESTCRED UNIBANCO S.A."),
            '29' => \MapasCulturais\i::__("029 - BANCO ITAÚ CONSIGNADO S.A."),
            '217' => \MapasCulturais\i::__("217 - BANCO JOHN DEERE S.A."),
            '243' => \MapasCulturais\i::__("243 - BANCO MASTER"),
            '719' => \MapasCulturais\i::__("719 - BANCO MASTER MÚLTIPLO"),
            '212' => \MapasCulturais\i::__("212 - BANCO ORIGINAL"),
            '623' => \MapasCulturais\i::__("623 - BANCO PAN"),
            '88' => \MapasCulturais\i::__("088 - BANCO RANDON S.A."),
            '743' => \MapasCulturais\i::__("743 - BANCO SEMEAR"),
            '756' => \MapasCulturais\i::__("756 - BANCO SICOOB S.A."),
            '754' => \MapasCulturais\i::__("754 - BANCO SISTEMA"),
            '82' => \MapasCulturais\i::__("082 - BANCO TOPÁZIO S.A."),
            '653' => \MapasCulturais\i::__("653 - BANCO VOITER"),
            '81' => \MapasCulturais\i::__("081 - BANCOSEGURO S.A."),
            '591' => \MapasCulturais\i::__("591 - BANVOX DTVM"),
            '268' => \MapasCulturais\i::__("268 - BARI CIA HIPOTECÁRIA"),
            '246' => \MapasCulturais\i::__("246 - BCO ABC BRASIL S.A."),
            '299' => \MapasCulturais\i::__("299 - BCO AFINZ S.A. - BM"),
            '121' => \MapasCulturais\i::__("121 - BCO AGIBANK S.A."),
            '25' => \MapasCulturais\i::__("025 - BCO ALFA S.A."),
            '65' => \MapasCulturais\i::__("065 - BCO ANDBANK S.A."),
            '213' => \MapasCulturais\i::__("213 - BCO ARBI S.A."),
            '96' => \MapasCulturais\i::__("096 - BCO B3 S.A."),
            '24' => \MapasCulturais\i::__("024 - BCO BANDEPE S.A."),
            '21' => \MapasCulturais\i::__("021 - BCO BANESTES S.A."),
            '36' => \MapasCulturais\i::__("036 - BCO BBI S.A."),
            '318' => \MapasCulturais\i::__("318 - BCO BMG S.A."),
            '752' => \MapasCulturais\i::__("752 - BCO BNP PARIBAS BRASIL S A"),
            '107' => \MapasCulturais\i::__("107 - BCO BOCOM BBM S.A."),
            '122' => \MapasCulturais\i::__("122 - BCO BRADESCO BERJ S.A."),
            '394' => \MapasCulturais\i::__("394 - BCO BRADESCO FINANC. S.A."),
            '237' => \MapasCulturais\i::__("237 - BCO BRADESCO S.A."),
            '378' => \MapasCulturais\i::__("378 - BCO BRASILEIRO DE CRÉDITO S.A."),
            '218' => \MapasCulturais\i::__("218 - BCO BS2 S.A."),
            '413' => \MapasCulturais\i::__("413 - BCO BV S.A."),
            '626' => \MapasCulturais\i::__("626 - BCO C6 CONSIG"),
            '336' => \MapasCulturais\i::__("336 - BCO C6 S.A."),
            '473' => \MapasCulturais\i::__("473 - BCO CAIXA GERAL BRASIL S.A."),
            '40' => \MapasCulturais\i::__("040 - BCO CARGILL S.A."),
            '320' => \MapasCulturais\i::__("320 - BCO CCB BRASIL S.A."),
            '266' => \MapasCulturais\i::__("266 - BCO CEDULA S.A."),
            '745' => \MapasCulturais\i::__("745 - BCO CITIBANK S.A."),
            '241' => \MapasCulturais\i::__("241 - BCO CLASSICO S.A."),
            '748' => \MapasCulturais\i::__("748 - BCO COOPERATIVO SICREDI S.A."),
            '222' => \MapasCulturais\i::__("222 - BCO CRÉDIT AGRICOLE BR S.A."),
            '505' => \MapasCulturais\i::__("505 - BCO CREDIT SUISSE S.A."),
            '69' => \MapasCulturais\i::__("069 - BCO CREFISA S.A."),
            '368' => \MapasCulturais\i::__("368 - BCO CSF S.A."),
            '3' => \MapasCulturais\i::__("003 - BCO DA AMAZONIA S.A."),
            '83' => \MapasCulturais\i::__("083 - BCO DA CHINA BRASIL S.A."),
            '707' => \MapasCulturais\i::__("707 - BCO DAYCOVAL S.A"),
            '654' => \MapasCulturais\i::__("654 - BCO DIGIMAIS S.A."),
            '1' => \MapasCulturais\i::__("001 - BCO DO BRASIL S.A."),
            '47' => \MapasCulturais\i::__("047 - BCO DO EST. DE SE S.A."),
            '37' => \MapasCulturais\i::__("037 - BCO DO EST. DO PA S.A."),
            '41' => \MapasCulturais\i::__("041 - BCO DO ESTADO DO RS S.A."),
            '4' => \MapasCulturais\i::__("004 - BCO DO NORDESTE DO BRASIL S.A."),
            '265' => \MapasCulturais\i::__("265 - BCO FATOR S.A."),
            '224' => \MapasCulturais\i::__("224 - BCO FIBRA S.A."),
            '390' => \MapasCulturais\i::__("390 - BCO GM S.A."),
            '612' => \MapasCulturais\i::__("612 - BCO GUANABARA S.A."),
            '269' => \MapasCulturais\i::__("269 - BCO HSBC S.A."),
            '604' => \MapasCulturais\i::__("604 - BCO INDUSTRIAL DO BRASIL S.A."),
            '479' => \MapasCulturais\i::__("479 - BCO ITAUBANK S.A."),
            '376' => \MapasCulturais\i::__("376 - BCO J.P. MORGAN S.A."),
            '76' => \MapasCulturais\i::__("076 - BCO KDB BRASIL S.A."),
            '757' => \MapasCulturais\i::__("757 - BCO KEB HANA DO BRASIL S.A."),
            '300' => \MapasCulturais\i::__("300 - BCO LA NACION ARGENTINA"),
            '495' => \MapasCulturais\i::__("495 - BCO LA PROVINCIA B AIRES BCE"),
            '630' => \MapasCulturais\i::__("630 - BCO LETSBANK S.A."),
            '600' => \MapasCulturais\i::__("600 - BCO LUSO BRASILEIRO S.A."),
            '389' => \MapasCulturais\i::__("389 - BCO MERCANTIL DO BRASIL S.A."),
            '381' => \MapasCulturais\i::__("381 - BCO MERCEDES-BENZ S.A."),
            '370' => \MapasCulturais\i::__("370 - BCO MIZUHO S.A."),
            '746' => \MapasCulturais\i::__("746 - BCO MODAL S.A."),
            '66' => \MapasCulturais\i::__("066 - BCO MORGAN STANLEY S.A."),
            '456' => \MapasCulturais\i::__("456 - BCO MUFG BRASIL S.A."),
            '611' => \MapasCulturais\i::__("611 - BCO PAULISTA S.A."),
            '643' => \MapasCulturais\i::__("643 - BCO PINE S.A."),
            '747' => \MapasCulturais\i::__("747 - BCO RABOBANK INTL BRASIL S.A."),
            '633' => \MapasCulturais\i::__("633 - BCO RENDIMENTO S.A."),
            '741' => \MapasCulturais\i::__("741 - BCO RIBEIRAO PRETO S.A."),
            '720' => \MapasCulturais\i::__("720 - BCO RNX S.A."),
            '120' => \MapasCulturais\i::__("120 - BCO RODOBENS S.A."),
            '422' => \MapasCulturais\i::__("422 - BCO SAFRA S.A."),
            '33' => \MapasCulturais\i::__("033 - BCO SANTANDER (BRASIL) S.A."),
            '276' => \MapasCulturais\i::__("276 - BCO SENFF S.A."),
            '366' => \MapasCulturais\i::__("366 - BCO SOCIETE GENERALE BRASIL"),
            '637' => \MapasCulturais\i::__("637 - BCO SOFISA S.A."),
            '464' => \MapasCulturais\i::__("464 - BCO SUMITOMO MITSUI BRASIL S.A."),
            '387' => \MapasCulturais\i::__("387 - BCO TOYOTA DO BRASIL S.A."),
            '634' => \MapasCulturais\i::__("634 - BCO TRIANGULO S.A."),
            '18' => \MapasCulturais\i::__("018 - BCO TRICURY S.A."),
            '393' => \MapasCulturais\i::__("393 - BCO VOLKSWAGEN S.A"),
            '655' => \MapasCulturais\i::__("655 - BCO VOTORANTIM S.A."),
            '610' => \MapasCulturais\i::__("610 - BCO VR S.A."),
            '119' => \MapasCulturais\i::__("119 - BCO WESTERN UNION"),
            '124' => \MapasCulturais\i::__("124 - BCO WOORI BANK DO BRASIL S.A."),
            '348' => \MapasCulturais\i::__("348 - BCO XP S.A."),
            '475' => \MapasCulturais\i::__("475 - BCO YAMAHA MOTOR S.A."),
            '74' => \MapasCulturais\i::__("074 - BCO. J.SAFRA S.A."),
            '550' => \MapasCulturais\i::__("550 - BEETELLER"),
            '134' => \MapasCulturais\i::__("134 - BGC LIQUIDEZ DTVM LTDA"),
            '531' => \MapasCulturais\i::__("531 - BMP SCD S.A."),
            '274' => \MapasCulturais\i::__("274 - BMP SCMEPP LTDA"),
            '377' => \MapasCulturais\i::__("377 - BMS SCD S.A."),
            '7' => \MapasCulturais\i::__("007 - BNDES"),
            '547' => \MapasCulturais\i::__("547 - BNK DIGITAL SCD S.A."),
            '17' => \MapasCulturais\i::__("017 - BNY MELLON BCO S.A."),
            '755' => \MapasCulturais\i::__("755 - BOFA MERRILL LYNCH BM S.A."),
            '408' => \MapasCulturais\i::__("408 - BONUSPAGO SCD S.A."),
            '126' => \MapasCulturais\i::__("126 - BR PARTNERS BI"),
            '433' => \MapasCulturais\i::__("433 - BR-CAPITAL DTVM S.A."),
            '128' => \MapasCulturais\i::__("128 - BRAZA BANK S.A. BCO DE CÂMBIO"),
            '70' => \MapasCulturais\i::__("070 - BRB - BCO DE BRASILIA S.A."),
            '568' => \MapasCulturais\i::__("568 - BRCONDOS SCD S.A."),
            '173' => \MapasCulturais\i::__("173 - BRL TRUST DTVM SA"),
            '142' => \MapasCulturais\i::__("142 - BROKER BRASIL CC LTDA."),
            '11' => \MapasCulturais\i::__("011 - C.SUISSE HEDGING-GRIFFO CV S/A"),
            '104' => \MapasCulturais\i::__("104 - CAIXA ECONOMICA FEDERAL"),
            '465' => \MapasCulturais\i::__("465 - CAPITAL CONSIG SCD S.A."),
            '288' => \MapasCulturais\i::__("288 - CAROL DTVM LTDA."),
            '324' => \MapasCulturais\i::__("324 - CARTOS SCD S.A."),
            '130' => \MapasCulturais\i::__("130 - CARUANA SCFI"),
            '159' => \MapasCulturais\i::__("159 - CASA CREDITO S.A. SCM"),
            '421' => \MapasCulturais\i::__("421 - CC LAR CREDI"),
            '584' => \MapasCulturais\i::__("584 - CCC POUP E INV DOS ESTADOS DO PR, SP E RJ"),
            '582' => \MapasCulturais\i::__("582 - CCC POUP INV DE MS, GO, DF E TO"),
            '583' => \MapasCulturais\i::__("583 - CCC POUP INV DO CENTRO NORTE DO BRASIL"),
            '580' => \MapasCulturais\i::__("580 - CCCPOUPINV SUL E SUDESTE - CENTRAL SUL/SUDESTE"),
            '16' => \MapasCulturais\i::__("016 - CCM DESP TRÂNS SC E RS"),
            '281' => \MapasCulturais\i::__("281 - CCR COOPAVEL"),
            '322' => \MapasCulturais\i::__("322 - CCR DE ABELARDO LUZ"),
            '391' => \MapasCulturais\i::__("391 - CCR DE IBIAM"),
            '273' => \MapasCulturais\i::__("273 - CCR DE SÃO MIGUEL DO OESTE"),
            '430' => \MapasCulturais\i::__("430 - CCR SEARA"),
            '470' => \MapasCulturais\i::__("470 - CDC SCD S.A."),
            '379' => \MapasCulturais\i::__("379 - CECM COOPERFORTE"),
            '385' => \MapasCulturais\i::__("385 - CECM DOS TRAB.PORT. DA G.VITOR"),
            '328' => \MapasCulturais\i::__("328 - CECM FABRIC CALÇADOS SAPIRANGA"),
            '471' => \MapasCulturais\i::__("471 - CECM SERV PUBL PINHÃO"),
            '509' => \MapasCulturais\i::__("509 - CELCOIN IP S.A."),
            '581' => \MapasCulturais\i::__("581 - CENTRAL NORDESTE"),
            '362' => \MapasCulturais\i::__("362 - CIELO IP S.A."),
            '477' => \MapasCulturais\i::__("477 - CITIBANK N.A."),
            '542' => \MapasCulturais\i::__("542 - CLOUDWALK IP LTDA"),
            '180' => \MapasCulturais\i::__("180 - CM CAPITAL MARKETS CCTVM LTDA"),
            '402' => \MapasCulturais\i::__("402 - COBUCCIO S.A. SCFI"),
            '127' => \MapasCulturais\i::__("127 - CODEPE CVC S.A."),
            '423' => \MapasCulturais\i::__("423 - COLUNA S.A. DTVM"),
            '136' => \MapasCulturais\i::__("136 - CONF NAC COOP CENTRAIS UNICRED"),
            '60' => \MapasCulturais\i::__("060 - CONFIDENCE CC S.A."),
            '569' => \MapasCulturais\i::__("569 - CONTA PRONTA IP"),
            '400' => \MapasCulturais\i::__("400 - COOP CREDITAG"),
            '350' => \MapasCulturais\i::__("350 - COOP DE AGRICULTORES E AEROPORTUÁRIOS DO BRASIL"),
            '85' => \MapasCulturais\i::__("085 - COOPCENTRAL AILOS"),
            '543' => \MapasCulturais\i::__("543 - COOPCRECE"),
            '403' => \MapasCulturais\i::__("403 - CORA SCFI"),
            '427' => \MapasCulturais\i::__("427 - CRED-UFES"),
            '98' => \MapasCulturais\i::__("098 - CREDIALIANÇA CCR"),
            '429' => \MapasCulturais\i::__("429 - CREDIARE CFI S.A."),
            '440' => \MapasCulturais\i::__("440 - CREDIBRF COOP"),
            '10' => \MapasCulturais\i::__("010 - CREDICOAMO"),
            '452' => \MapasCulturais\i::__("452 - CREDIFIT SCD S.A."),
            '443' => \MapasCulturais\i::__("443 - CREDIHOME SCD"),
            '89' => \MapasCulturais\i::__("089 - CREDISAN CC"),
            '97' => \MapasCulturais\i::__("097 - CREDISIS - CENTRAL DE COOPERATIVAS DE CRÉDITO LTDA."),
            '342' => \MapasCulturais\i::__("342 - CREDITAS SCD"),
            '428' => \MapasCulturais\i::__("428 - CREDSYSTEM SCD S.A."),
            '321' => \MapasCulturais\i::__("321 - CREFAZ SCMEPP SA"),
            '133' => \MapasCulturais\i::__("133 - CRESOL CONFEDERAÇÃO"),
            '435' => \MapasCulturais\i::__("435 - DELCRED SCD S.A."),
            '487' => \MapasCulturais\i::__("487 - DEUTSCHE BANK S.A.BCO ALEMAO"),
            '575' => \MapasCulturais\i::__("575 - DGBK CREDIT S.A. - SOCIEDADE DE CRÉDITO DIRETO."),
            '449' => \MapasCulturais\i::__("449 - DM"),
            '646' => \MapasCulturais\i::__("646 - DM SA CFI"),
            '301' => \MapasCulturais\i::__("301 - DOCK IP S.A."),
            '664' => \MapasCulturais\i::__("664 - EAGLE IP LTDA."),
            '532' => \MapasCulturais\i::__("532 - EAGLE SCD S.A."),
            '383' => \MapasCulturais\i::__("383 - EBANX IP LTDA."),
            '144' => \MapasCulturais\i::__("144 - EBURY BCO DE CÂMBIO S.A."),
            '364' => \MapasCulturais\i::__("364 - EFÍ S.A. - IP"),
            '289' => \MapasCulturais\i::__("289 - EFX CC LTDA."),
            '534' => \MapasCulturais\i::__("534 - EWALLY IP S.A."),
            '514' => \MapasCulturais\i::__("514 - EXIM CC LTDA."),
            '395' => \MapasCulturais\i::__("395 - F D GOLD DTVM LTDA"),
            '149' => \MapasCulturais\i::__("149 - FACTA S.A. CFI"),
            '196' => \MapasCulturais\i::__("196 - FAIR CC S.A."),
            '541' => \MapasCulturais\i::__("541 - FDO GARANTIDOR CRÉDITOS"),
            '455' => \MapasCulturais\i::__("455 - FÊNIX DTVM LTDA."),
            '343' => \MapasCulturais\i::__("343 - FFA SCMEPP LTDA."),
            '510' => \MapasCulturais\i::__("510 - FFCRED SCD S.A."),
            '587' => \MapasCulturais\i::__("587 - FIDD DTVM LTDA."),
            '382' => \MapasCulturais\i::__("382 - FIDUCIA SCMEPP LTDA"),
            '512' => \MapasCulturais\i::__("512 - FINVEST DTVM"),
            '450' => \MapasCulturais\i::__("450 - FITBANK IP"),
            '566' => \MapasCulturais\i::__("566 - FLAGSHIP IP LTDA"),
            '305' => \MapasCulturais\i::__("305 - FOURTRADE COR. DE CAMBIO LTDA"),
            '661' => \MapasCulturais\i::__("661 - FREEX CC S.A."),
            '285' => \MapasCulturais\i::__("285 - FRENTE CC S.A."),
            '589' => \MapasCulturais\i::__("589 - G5 SCD SA"),
            '292' => \MapasCulturais\i::__("292 - GALAPAGOS DTVM S.A."),
            '478' => \MapasCulturais\i::__("478 - GAZINCRED S.A. SCFI"),
            '278' => \MapasCulturais\i::__("278 - GENIAL INVESTIMENTOS CVM S.A."),
            '138' => \MapasCulturais\i::__("138 - GET MONEY CC LTDA"),
            '384' => \MapasCulturais\i::__("384 - GLOBAL SCM LTDA"),
            '64' => \MapasCulturais\i::__("064 - GOLDMAN SACHS DO BRASIL BM S.A"),
            '177' => \MapasCulturais\i::__("177 - GUIDE"),
            '146' => \MapasCulturais\i::__("146 - GUITTA CC LTDA"),
            '78' => \MapasCulturais\i::__("078 - HAITONG BI DO BRASIL S.A."),
            '540' => \MapasCulturais\i::__("540 - HBI SCD"),
            '458' => \MapasCulturais\i::__("458 - HEDGE INVESTMENTS DTVM LTDA."),
            '448' => \MapasCulturais\i::__("448 - HEMERA DTVM LTDA."),
            '62' => \MapasCulturais\i::__("062 - HIPERCARD BM S.A."),
            '523' => \MapasCulturais\i::__("523 - HR DIGITAL SCD"),
            '189' => \MapasCulturais\i::__("189 - HS FINANCEIRA"),
            '312' => \MapasCulturais\i::__("312 - HSCM SCMEPP LTDA."),
            '396' => \MapasCulturais\i::__("396 - HUB IP S.A."),
            '271' => \MapasCulturais\i::__("271 - IB CCTVM S.A."),
            '157' => \MapasCulturais\i::__("157 - ICAP DO BRASIL CTVM LTDA."),
            '132' => \MapasCulturais\i::__("132 - ICBC DO BRASIL BM S.A."),
            '439' => \MapasCulturais\i::__("439 - ID CTVM"),
            '398' => \MapasCulturais\i::__("398 - IDEAL CTVM S.A."),
            '525' => \MapasCulturais\i::__("525 - INTERCAM CC LTDA"),
            '139' => \MapasCulturais\i::__("139 - INTESA SANPAOLO BRASIL S.A. BM"),
            '549' => \MapasCulturais\i::__("549 - INTRA DTVM"),
            '597' => \MapasCulturais\i::__("597 - ISSUER IP LTDA."),
            '341' => \MapasCulturais\i::__("341 - ITAÚ UNIBANCO S.A."),
            '401' => \MapasCulturais\i::__("401 - IUGU IP S.A."),
            '451' => \MapasCulturais\i::__("451 - J17 - SCD S/A"),
            '488' => \MapasCulturais\i::__("488 - JPMORGAN CHASE BANK"),
            '559' => \MapasCulturais\i::__("559 - KANASTRA SCD"),
            '399' => \MapasCulturais\i::__("399 - KIRTON BANK"),
            '416' => \MapasCulturais\i::__("416 - LAMARA SCD S.A."),
            '293' => \MapasCulturais\i::__("293 - LASTRO RDV DTVM LTDA"),
            '105' => \MapasCulturais\i::__("105 - LECCA CFI S.A."),
            '414' => \MapasCulturais\i::__("414 - LEND SCD S.A."),
            '145' => \MapasCulturais\i::__("145 - LEVYCAM CCV LTDA"),
            '519' => \MapasCulturais\i::__("519 - LIONS TRUST DTVM"),
            '397' => \MapasCulturais\i::__("397 - LISTO SCD S.A."),
            '484' => \MapasCulturais\i::__("484 - MAF DTVM SA"),
            '560' => \MapasCulturais\i::__("560 - MAG IP LTDA."),
            '511' => \MapasCulturais\i::__("511 - MAGNUM SCD"),
            '592' => \MapasCulturais\i::__("592 - MAPS IP LTDA."),
            '141' => \MapasCulturais\i::__("141 - MASTER BI S.A."),
            '467' => \MapasCulturais\i::__("467 - MASTER S/A CCTVM"),
            '576' => \MapasCulturais\i::__("576 - MERCADO BITCOIN IP LTDA"),
            '518' => \MapasCulturais\i::__("518 - MERCADO CRÉDITO SCFI S.A."),
            '323' => \MapasCulturais\i::__("323 - MERCADO PAGO IP LTDA."),
            '567' => \MapasCulturais\i::__("567 - MERCANTIL FINANCEIRA"),
            '454' => \MapasCulturais\i::__("454 - MÉRITO DTVM LTDA."),
            '537' => \MapasCulturais\i::__("537 - MICROCASH SCMEPP LTDA."),
            '358' => \MapasCulturais\i::__("358 - MIDWAY S.A. - SCFI"),
            '447' => \MapasCulturais\i::__("447 - MIRAE ASSET (BRASIL) CCTVM LTDA."),
            '526' => \MapasCulturais\i::__("526 - MONETARIE SCD"),
            '259' => \MapasCulturais\i::__("259 - MONEYCORP BCO DE CÂMBIO S.A."),
            '544' => \MapasCulturais\i::__("544 - MULTICRED SCD S.A."),
            '113' => \MapasCulturais\i::__("113 - NEON CTVM S.A."),
            '426' => \MapasCulturais\i::__("426 - NEON FINANCEIRA - CFI S.A."),
            '536' => \MapasCulturais\i::__("536 - NEON PAGAMENTOS S.A. IP"),
            '614' => \MapasCulturais\i::__("614 - NITRO SCD S.A."),
            '191' => \MapasCulturais\i::__("191 - NOVA FUTURA CTVM LTDA."),
            '753' => \MapasCulturais\i::__("753 - NOVO BCO CONTINENTAL S.A. - BM"),
            '386' => \MapasCulturais\i::__("386 - NU FINANCEIRA S.A. CFI"),
            '140' => \MapasCulturais\i::__("140 - NU INVEST CORRETORA DE VALORES S.A."),
            '260' => \MapasCulturais\i::__("260 - NU PAGAMENTOS - IP"),
            '419' => \MapasCulturais\i::__("419 - NUMBRS SCD S.A."),
            '111' => \MapasCulturais\i::__("111 - OLIVEIRA TRUST DTVM S.A."),
            '319' => \MapasCulturais\i::__("319 - OM DTVM LTDA"),
            '613' => \MapasCulturais\i::__("613 - OMNI BANCO S.A."),
            '659' => \MapasCulturais\i::__("659 - ONEKEY PAYMENTS IP S.A."),
            '535' => \MapasCulturais\i::__("535 - OPEA SCD"),
            '325' => \MapasCulturais\i::__("325 - ÓRAMA DTVM S.A."),
            '331' => \MapasCulturais\i::__("331 - OSLO CAPITAL DTVM SA"),
            '355' => \MapasCulturais\i::__("355 - ÓTIMO SCD S.A."),
            '712' => \MapasCulturais\i::__("712 - OURIBANK S.A."),
            '296' => \MapasCulturais\i::__("296 - OZ CORRETORA DE CÂMBIO S.A."),
            '651' => \MapasCulturais\i::__("651 - PAGARE IP S.A."),
            '557' => \MapasCulturais\i::__("557 - PAGPRIME IP"),
            '290' => \MapasCulturais\i::__("290 - PAGSEGURO INTERNET IP S.A."),
            '555' => \MapasCulturais\i::__("555 - PAN CFI"),
            '254' => \MapasCulturais\i::__("254 - PARANA BCO S.A."),
            '326' => \MapasCulturais\i::__("326 - PARATI - CFI S.A."),
            '561' => \MapasCulturais\i::__("561 - PAY4FUN IP S.A."),
            '521' => \MapasCulturais\i::__("521 - PEAK SEP S.A."),
            '174' => \MapasCulturais\i::__("174 - PEFISA S.A. - C.F.I."),
            '553' => \MapasCulturais\i::__("553 - PERCAPITAL SCD S.A."),
            '380' => \MapasCulturais\i::__("380 - PICPAY"),
            '79' => \MapasCulturais\i::__("079 - PICPAY BANK - BANCO MÚLTIPLO S.A"),
            '469' => \MapasCulturais\i::__("469 - PICPAY INVEST"),
            '529' => \MapasCulturais\i::__("529 - PINBANK IP"),
            '100' => \MapasCulturais\i::__("100 - PLANNER CV S.A."),
            '410' => \MapasCulturais\i::__("410 - PLANNER SOCIEDADE DE CRÉDITO DIRETO"),
            '445' => \MapasCulturais\i::__("445 - PLANTAE CFI"),
            '93' => \MapasCulturais\i::__("093 - POLOCRED SCMEPP LTDA."),
            '306' => \MapasCulturais\i::__("306 - PORTOPAR DTVM LTDA"),
            '556' => \MapasCulturais\i::__("556 - PROSEFTUR"),
            '563' => \MapasCulturais\i::__("563 - PROTEGE PAY CASH IP S.A."),
            '588' => \MapasCulturais\i::__("588 - PROVER PROMOCAO DE VENDAS IP LTDA."),
            '558' => \MapasCulturais\i::__("558 - QI DTVM LTDA."),
            '329' => \MapasCulturais\i::__("329 - QI SCD S.A."),
            '516' => \MapasCulturais\i::__("516 - QISTA S.A. CFI"),
            '579' => \MapasCulturais\i::__("579 - QUADRA SCD"),
            '283' => \MapasCulturais\i::__("283 - RB INVESTIMENTOS DTVM LTDA."),
            '528' => \MapasCulturais\i::__("528 - REAG DTVM S.A."),
            '374' => \MapasCulturais\i::__("374 - REALIZE CFI S.A."),
            '522' => \MapasCulturais\i::__("522 - RED SCD S.A."),
            '101' => \MapasCulturais\i::__("101 - RENASCENCA DTVM LTDA"),
            '590' => \MapasCulturais\i::__("590 - REPASSES FINANCEIROS E SOLUCOES TECNOLOGICAS IP S.A."),
            '620' => \MapasCulturais\i::__("620 - REVOLUT SCD S.A."),
            '506' => \MapasCulturais\i::__("506 - RJI"),
            '548' => \MapasCulturais\i::__("548 - RPW S.A. SCFI"),
            '539' => \MapasCulturais\i::__("539 - SANTINVEST S.A. - CFI"),
            '482' => \MapasCulturais\i::__("482 - SBCASH SCD"),
            '507' => \MapasCulturais\i::__("507 - SCFI EFÍ S.A."),
            '751' => \MapasCulturais\i::__("751 - SCOTIABANK BRASIL"),
            '407' => \MapasCulturais\i::__("407 - SEFER INVESTIMENTOS DTVM LTDA"),
            '545' => \MapasCulturais\i::__("545 - SENSO CCVM S.A."),
            '530' => \MapasCulturais\i::__("530 - SER FINANCE SCD S.A."),
            '190' => \MapasCulturais\i::__("190 - SERVICOOP"),
            '585' => \MapasCulturais\i::__("585 - SETHI SCD SA"),
            '578' => \MapasCulturais\i::__("578 - SICRES"),
            '365' => \MapasCulturais\i::__("365 - SIMPAUL"),
            '363' => \MapasCulturais\i::__("363 - SINGULARE CTVM S.A."),
            '84' => \MapasCulturais\i::__("084 - SISPRIME DO BRASIL - COOP"),
            '412' => \MapasCulturais\i::__("412 - SOCIAL BANK S/A"),
            '425' => \MapasCulturais\i::__("425 - SOCINAL S.A. CFI"),
            '183' => \MapasCulturais\i::__("183 - SOCRED SA - SCMEPP"),
            '520' => \MapasCulturais\i::__("520 - SOMAPAY SCD S.A."),
            '533' => \MapasCulturais\i::__("533 - SRM BANK"),
            '462' => \MapasCulturais\i::__("462 - STARK SCD S.A."),
            '14' => \MapasCulturais\i::__("014 - STATE STREET BR S.A. BCO COMERCIAL"),
            '197' => \MapasCulturais\i::__("197 - STONE IP S.A."),
            '554' => \MapasCulturais\i::__("554 - STONEX BANCO DE CÂMBIO S.A."),
            '538' => \MapasCulturais\i::__("538 - SUDACRED SCD S.A."),
            '404' => \MapasCulturais\i::__("404 - SUMUP SCD S.A."),
            '340' => \MapasCulturais\i::__("340 - SUPERDIGITAL I.P. S.A."),
            '481' => \MapasCulturais\i::__("481 - SUPERLÓGICA SCD S.A."),
            '307' => \MapasCulturais\i::__("307 - TERRA INVESTIMENTOS DTVM"),
            '352' => \MapasCulturais\i::__("352 - TORO CTVM S.A."),
            '593' => \MapasCulturais\i::__("593 - TRANSFEERA IP S.A."),
            '95' => \MapasCulturais\i::__("095 - TRAVELEX BANCO DE CÂMBIO S.A."),
            '143' => \MapasCulturais\i::__("143 - TREVISO CC S.A."),
            '360' => \MapasCulturais\i::__("360 - TRINUS CAPITAL DTVM"),
            '444' => \MapasCulturais\i::__("444 - TRINUS SCD S.A."),
            '619' => \MapasCulturais\i::__("619 - TRIO IP LTDA."),
            '438' => \MapasCulturais\i::__("438 - TRUSTEE DTVM LTDA."),
            '131' => \MapasCulturais\i::__("131 - TULLETT PREBON BRASIL CVC LTDA"),
            '546' => \MapasCulturais\i::__("546 - U4C INSTITUIÇÃO DE PAGAMENTO S.A."),
            '129' => \MapasCulturais\i::__("129 - UBS BRASIL BI S.A."),
            '15' => \MapasCulturais\i::__("015 - UBS BRASIL CCTVM S.A."),
            '460' => \MapasCulturais\i::__("460 - UNAVANTI SCD S/A"),
            '194' => \MapasCulturais\i::__("194 - UNIDA DTVM LTDA"),
            '99' => \MapasCulturais\i::__("099 - UNIPRIME COOPCENTRAL LTDA."),
            '373' => \MapasCulturais\i::__("373 - UP.P SEP S.A."),
            '457' => \MapasCulturais\i::__("457 - UY3 SCD S/A"),
            '552' => \MapasCulturais\i::__("552 - UZZIPAY IP S.A."),
            '195' => \MapasCulturais\i::__("195 - VALOR SCD S.A."),
            '551' => \MapasCulturais\i::__("551 - VERT DTVM LTDA."),
            '298' => \MapasCulturais\i::__("298 - VIPS CC LTDA."),
            '310' => \MapasCulturais\i::__("310 - VORTX DTVM LTDA."),
            '371' => \MapasCulturais\i::__("371 - WARREN CVMC LTDA"),
            '280' => \MapasCulturais\i::__("280 - WILL FINANCEIRA S.A.CFI"),
            '524' => \MapasCulturais\i::__("524 - WNT CAPITAL DTVM"),
            '102' => \MapasCulturais\i::__("102 - XP INVESTIMENTOS CCTVM S/A"),
            '586' => \MapasCulturais\i::__("586 - Z1 IP LTDA."),
            '359' => \MapasCulturais\i::__("359 - ZEMA CFI S/A"),
            '418' => \MapasCulturais\i::__("418 - ZIPDIN SCD S.A."),
            '595' => \MapasCulturais\i::__("595 - ZOOP MEIOS DE PAGAMENTO")
        ],
        'account_types' => [
            '1' => \MapasCulturais\i::__('Conta corrente'),
            '2' => \MapasCulturais\i::__('Conta Poupança')
        ]
    ]
];
