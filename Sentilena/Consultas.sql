--- Dados Da Instancia 
-- Menu: Instância->Informações
--- Query (Dados Da Instancia)->(Instância)->(Informações da Instância)
select * from v$instance

--- Query (Dados Da Instancia)->(Instância)->(Informações do Banco de Dados)
select * from v$database

--- Query (Dados Da Instancia)->(Parametros)
select name, substr(value,1,60) value_param, isdefault, isses_modifiable, issys_modifiable, ismodified, isadjusted, description
  from v$parameter
  order by name

--- Query (Dados Da Instancia)->(Parametros não documentados)
select a.ksppinm NAME,substr(b.ksppstvl,1,60) VALUE, a.ksppdesc DESCRIPTION,b.ksppstdf ISDEFAULT 
  from x$ksppi a, x$ksppcv b  
 where a.indx = b.indx and a.ksppinm like '\_%' escape --'\'
  order by ksppinm


-- Menu: Instância->Sessões e bloqueios
--- Query (Sessões e bloqueios)->(Sessões)
-- SubQuery(Por Instancia)
select instance_number inst_id, ses.*, com.command_name dec_command, pro.spid, sta.value logic_reads 
  from v$instance, v$session ses, v$process pro, v$sesstat sta, v$sqlcommand com 
  where pro.addr = ses.paddr and sta.sid = ses.sid and sta.statistic# = 12 and com.command_type = ses.command and ses.type <> 'BACKGROUND'
order by ses.status,logic_reads desc

-- SubQuery(Por Usuário)
select instance_number inst_id, ses.*, com.command_name dec_command, pro.spid, sta.value logic_reads 
  from v$instance, v$session ses, v$process pro, v$sesstat sta, v$sqlcommand com 
 where pro.addr = ses.paddr and sta.sid = ses.sid and sta.statistic#  = 12 and com.command_type = ses.command and ses.type <> 'BACKGROUND'
order by ses.status, logic_reads desc

-- SubQuery(Por SID)
select instance_number inst_id, ses.*, com.command_name dec_command, pro.spid, sta.value logic_reads 
  from v$instance, v$session ses, v$process pro, v$sesstat sta, v$sqlcommand com 
 where pro.addr = ses.paddr and sta.sid = ses.sid and sta.statistic# = 12 and com.command_type = ses.command and ses.type <> 'BACKGROUND'
order by ses.status,logic_reads desc

-- SubQuery(Por ID SO)
select instance_number inst_id, ses.*, com.command_name dec_command, pro.spid, sta.value logic_reads
  from v$instance, v$session ses, v$process pro, v$sesstat sta, v$sqlcommand com 
 where pro.addr = ses.paddr and sta.sid = ses.sid and sta.statistic# = 12 and com.command_type = ses.commandand ses.type <> 'BACKGROUND'
order by ses.status,logic_reads desc

-- SubQuery(Por Usuário SO)
select instance_number inst_id, ses.*, com.command_name dec_command, pro.spid, sta.value logic_reads
  from v$instance, v$session ses, v$process pro, v$sesstat sta, v$sqlcommand com  
 where pro.addr = ses.paddr and sta.sid = ses.sid and sta.statistic# = 12 and com.command_type = ses.command and ses.type <> 'BACKGROUND'
order by ses.status,logic_reads desc

-- SubQuery(Por Computador)
select instance_number inst_id, ses.*, com.command_name dec_command, pro.spid, sta.value logic_reads 
  from v$instance, v$session ses, v$process pro, v$sesstat sta, v$sqlcommand com 
 where pro.addr = ses.paddr and sta.sid = ses.sid and sta.statistic# = 12 and com.command_type = ses.command and ses.type <> 'BACKGROUND'
order by ses.status,logic_reads desc

-- SubQuery(Por Programa)
select instance_number inst_id, ses.*, com.command_name dec_command, pro.spid,sta.value logic_reads
  from v$instance, v$session ses, v$process pro, v$sesstat sta, v$sqlcommand com 
 where pro.addr = ses.paddr and sta.sid = ses.sid and sta.statistic# = 12 and com.command_type = ses.command and ses.type <> 'BACKGROUND'
order by ses.status,logic_reads desc

-- SubQuery(Por Módulo)
select instance_number inst_id, ses.*, com.command_name dec_command,  pro.spid,sta.value logic_reads  from v$instance,v$session ses,v$process pro,v$sesstat sta,v$sqlcommand com  where pro.addr         = ses.paddr    and sta.sid          = ses.sid    and sta.statistic#   = 12    and com.command_type = ses.command
    and ses.type <> 'BACKGROUND'
order by ses.status,logic_reads desc


--- Query (Sessões e bloqueios)->(Bloqueio em Espera)
select sel.inst_id Locking_Inst, sel.username Locking_User, sel.sid Locking_Sid, sel.serial# Locking_Serial, sel.osuser Locking_OSUser, sel.program Locking_Program, sel.module Locking_Module, sel.status Locking_Status, sel.type Locking_Type, sel.sql_id Locking_SQLID, sew.inst_id Waiting_Inst, sew.username Waiting_User, sew.sid Waiter_Sid, sew.serial# Waiting_Serial, sew.osuser Waiting_OSUser, sew.program Waiting_Programa, sew.module Waiting_Module, sew.status Waiting_Status, sew.sql_id Waiting_SQLID, sew.wait_class, sew.seconds_in_wait, obj.owner object_owner, obj.object_name
from gv$session sel, gv$session sew, dba_objects obj
where sew.blocking_session is not NULL and sel.inst_id = sew.blocking_instance and sel.sid = sew.blocking_session and obj.data_object_id = sew.row_wait_obj# 
order by  sew.blocking_instance, sew.blocking_session


--- Query (Sessões e bloqueios)->(Sessão Selecionada)
--- Query (Sessões e bloqueios)->(Sessão Selecionada)->(Info da Sessão)->(Ternima Sessão)
alter system kill session '107,52169'


--- Query (Sessões e bloqueios)->(Sessão Selecionada)->(Info da Sessão)->(Cursor)
select are.sql_text, are.sql_fulltext from gv$sqlarea are where are.inst_id = 1 and are.sql_id = 'fvfjwunuqh1k6'
  

--- Query (Sessões e bloqueios)->(Sessão Selecionada)->(Info da Sessão)->(Plano de Acesso)
select distinct pla.operation, pla.object_type, pla.object_name, pla.options, pla.id, pla.parent_id, pla.position, pla.cardinality, pla.bytes, pla.cost, pla.optimizer
  FROM gv$sql_plan pla
 where pla.inst_id    = :INST_ID
   and pla.sql_id     = :SQL_ID
 order by id, parent_id
 

--- Query (Sessões e bloqueios)->(Sessão Selecionada)->(Info da Sessão)->(Bloqueios)
select loc.type, decode(loc.lmode, 0, 'None', 1, 'Null', 2, 'Row Share', 3, 'Row Excl.', 4, 'Share', 5, 'S/Row Excl.', 6, 'Exclusive', lmode, ltrim(to_char(loc.lmode,'990'))) lmode, decode(loc.request,0,'None', 1,'Null', 2,'Row Share', 3,'Row Excl.', 4,'Share', 5,'S/Row Excl.', 6,'Exclusive', request, ltrim(to_char(loc.request,'990'))) request, obj.object_name, obj.owner, obj.object_type, loc.ctime, loc.id1, loc.id2  
  from gv$lock loc, gv$locked_object loo, dba_objects obj  
 where loc.inst_id = 1 and loc.sid = 107 and loo.inst_id = loc.inst_id and loo.session_id = loc.sid and obj.object_id = loo.object_id 
 order by loc.type


--- Query (Sessões e bloqueios)->(Sessão Seleciona)->(Total de Sessões)
select /*+ rule */ status, type, count(*) qtde 
  from v$session  
 group by status, type

--- Query (Sessões e bloqueios)->(Sessão Seleciona)->(Memória em Mb utilizada pelas sessões (PGA))
select name, round(sum(value)/1024/1024) total_memo 
  from v$pgastat 
 where name like '%PGA allocated' 
 group by name

--- Query (Sessões e bloqueios)->(Sessão Seleciona)->(Sessões com mais de um dia de logon)
select instance_number inst_id, ses.*, com.command_name dec_command, pro.spid  
  from v$instance, v$session ses, v$process pro, v$sqlcommand com 
 where pro.addr = ses.paddr and com.command_type = ses.command and trunc(ses.logon_time) < trunc(SYSDATE) and upper(ses.osuser) <> 'ORACLE' 
 order by ses.logon_time, ses.status


--- Query (Sessões e bloqueios)->(Mais Informações)
--- Query (Sessões e bloqueios)->(Mais Informações)->(Total de Sessões)
select /*+ rule */ status, type, count(*) qtde 
  from v$session 
 group by status, type

--- Query (Sessões e bloqueios)->(Mais Informações)->(Memoria em MB Utilizada pelas Sessões (PGA))
select name, round(sum(value)/1024/1024) total_memo 
  from v$pgastat 
 where name like '%PGA allocated' 
 group by name

--- Query (Sessões e bloqueios)->(Mais Informações)->(Sessões com mais de um dia de logon)
select instance_number inst_id, ses.*, com.command_name dec_command, pro.spid 
  from v$instance, v$session ses, v$process pro, v$sqlcommand com 
 where pro.addr = ses.paddr and com.command_type = ses.command and trunc(ses.logon_time) < trunc(SYSDATE) and upper(ses.osuser) <> 'ORACLE'
 order by ses.logon_time,ses.status


--- Query (Dados da Instância)->(Instância)->(Informações da Instância)
select * from v$instance

--- Query (Dados da Instância)->(Instância)->(Informações do Banco de Dados)
select * from v$database


--- Query (Dados da Instância)->(Parâmentros)  
select name, substr(value,1,60) value_param, isdefault, isses_modifiable, issys_modifiable, ismodified, isadjusted, description 
  from v$parameter
 order by name


--- Query (Dados da Instância)->(Parâmentros não-documentados)
select a.ksppinm NAME, substr(b.ksppstvl,1,60) VALUE, a.ksppdesc DESCRIPTION, b.ksppstdf ISDEFAULT 
  from x$ksppi a, x$ksppcv b 
 where a.indx = b.indx and a.ksppinm like '\_%' escape  "'\'"
 order by ksppinm







--- Query (Objetos dos esquemas)->(Esquema)->(Schedules) 
select owner, job_name, program_owner, program_name, schedule_name, job_type, job_action, repeat_interval, event_condition, job_class, state, run_count, failure_count, enabled, to_char(start_date,'dd/mm/yyyy hh:mi:ss') start_date, to_char(last_start_date,'dd/mm/yyyy hh:mi:ss') last_start_date, to_char(next_run_date,'dd/mm/yyyy hh:mi:ss') next_run_date, extract(day from 24*60*60*last_run_duration) last_run_duration  
  from dba_scheduler_jobs  
 order by owner, job_name


--- Query (Objetos dos esquemas)->(Esquema)->(Database Links)  
select * 
  from dba_db_links  
 where owner is not null 
 order by owner,db_link


--- Query (Objetos dos esquemas)->(Esquema)->(Recycle Bin)  
??? Parace que não foi implementado a consulta

--- Query (Objetos dos esquemas)->(Esquema)->(Situação dos Objetos)  
--- Query (Objetos dos esquemas)->(Esquema)->(Situação dos Objetos)->(Resumo)  
select obj1.object_type, count(*) TOTAL, (select count(*) from dba_objects obj2 where obj2.owner is not null and obj2.object_name not like 'BIN$%'           and obj2.object_type = obj1.object_type           and obj2.status      = 'INVALID') INVALIDO,      (select count(*) from dba_objects obj3         where obj3.owner       is not null           and obj3.object_name like 'BIN$%'           and obj3.object_type = obj1.object_type) DROPPED  from dba_objects obj1  where obj1.owner is not null    and obj1.object_type not in ('TRIGGER','INDEX','INDEX PARTITION')  group by obj1.object_type union select 'JOB (OLD)' OBJECT_TYPE,count(*) TOTAL,       0 INVALIDO,       0 DROPPED  from dba_jobs job1  where job1.schema_user is not null  group by 1 union select 'CONSTRAINT' OBJECT_TYPE,count(*) TOTAL,      (select count(*) from dba_constraints con2         where con2.owner is not null           and con2.constraint_name not like 'BIN$%'           and con2.status = 'DISABLED') INVALIDO,      (select count(*) from dba_constraints con3         where con3.owner is not null           and con3.constraint_name like 'BIN$%') DROPPED  from dba_constraints con1  where con1.owner is not null  group by 1 union select 'INDEX' OBJECT_TYPE,count(*) TOTAL,      (select count(*) from dba_indexes ind2         where ind2.owner is not null           and ind2.index_name not like 'BIN$%'           and ind2.status = 'UNUSABLE') INVALIDO,      (select count(*) from dba_indexes ind3         where ind3.owner is not null           and ind3.index_name like 'BIN$%') DROPPED  from dba_indexes ind1  where ind1.owner is not null  group by 1 union select 'INDEX PARTITION' OBJECT_TYPE,count(*) TOTAL,      (select count(*) from dba_ind_partitions ipa2         where ipa2.index_owner is not null           and ipa2.index_name not like 'BIN$%'           and ipa2.status = 'UNUSABLE') INVALIDO,      (select count(*) from dba_ind_partitions ipa3         where ipa3.index_owner is not null           and ipa3.index_name like 'BIN$%') DROPPED  from dba_ind_partitions ipa1  where ipa1.index_owner is not null  group by 1 union select 'TRIGGER' OBJECT_TYPE,count(*) TOTAL,      (select count(*) from dba_triggers trg2         where trg2.owner is not null           and trg2.trigger_name not like 'BIN$%'           and trg2.status in ('DISABLED','INVALID')) INVALIDO,      (select count(*) from dba_triggers trg3         where trg3.owner is not null           and trg3.trigger_name like 'BIN$%') DROPPED  from dba_triggers trg1  where trg1.owner is not null  group by 1  order by 1

--- Query (Objetos dos esquemas)->(Esquema)->(Situação dos Objetos)->(Objetos Invalidos)  
select owner ESQUEMA,constraint_name OBJETO,table_name TABELA,status STATUS_OBJ from dba_constraints  where owner is not null    and status = 'DISABLED'  order by owner,constraint_name


--- Query (Objetos dos esquemas)->(Esquema)->(Todos os Objetos) 
--- Query (Objetos dos esquemas)->(Esquema)->(Todos os Objetos)->(Todos) 
select owner,object_name OBJETO,object_type TIPO,created CRIACAO,       last_ddl_time ULT_MODIF,status from dba_objects  where owner       is not null    and object_type in ('TABLE','VIEW','INDEX','TRIGGER','PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','SEQUENCE','SYNONYM','DATABASE LINK') 
union 
select owner,constraint_name OBJETO,'CONSTRAINT' TIPO,last_change CRIACAO,       last_change ULT_MODIF,status from dba_constraints  where owner is not null 
union 
select owner,object_name OBJETO,object_type TIPO,created CRIACAO,       last_ddl_time ULT_MODIF,status from dba_objects  where owner      is not null    and object_type not in ('TABLE','VIEW','INDEX','TRIGGER',        'PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','SEQUENCE','SYNONYM',        'DATABASE LINK')
order by 2,1

--- Query (Objetos dos esquemas)->(Esquema)->(Todos os Objetos)->(Válidos) 
select owner,object_name OBJETO,object_type TIPO,created CRIACAO,       last_ddl_time ULT_MODIF,status from dba_objects  where owner       is not null    and object_type in ('TABLE','VIEW','INDEX','TRIGGER','PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','SEQUENCE','SYNONYM','DATABASE LINK') 
    and status = 'VALID' 
union 
select owner,constraint_name OBJETO,'CONSTRAINT' TIPO,last_change CRIACAO,       last_change ULT_MODIF,status from dba_constraints  where owner is not null 
    and status = 'ENABLED' 
union 
select owner,object_name OBJETO,object_type TIPO,created CRIACAO,       last_ddl_time ULT_MODIF,status from dba_objects  where owner      is not null    and object_type not in ('TABLE','VIEW','INDEX','TRIGGER',        'PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','SEQUENCE','SYNONYM',        'DATABASE LINK')
    and status = 'VALID' 
order by 2,1

--- Query (Objetos dos esquemas)->(Esquema)->(Todos os Objetos)->(Invalidos) 
select owner,object_name OBJETO,object_type TIPO,created CRIACAO,       last_ddl_time ULT_MODIF,status from dba_objects  where owner       is not null    and object_type in ('TABLE','VIEW','INDEX','TRIGGER','PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','SEQUENCE','SYNONYM','DATABASE LINK') 
    and status = 'INVALID' 
union 
select owner,constraint_name OBJETO,'CONSTRAINT' TIPO,last_change CRIACAO,       last_change ULT_MODIF,status from dba_constraints  where owner is not null 
    and status = 'DISABLED' 
union 
select owner,object_name OBJETO,object_type TIPO,created CRIACAO,       last_ddl_time ULT_MODIF,status from dba_objects  where owner      is not null    and object_type not in ('TABLE','VIEW','INDEX','TRIGGER',        'PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','SEQUENCE','SYNONYM',        'DATABASE LINK')
    and status = 'INVALID' 
order by 2,1


--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)
--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Colunas)
select column_id,column_name,       decode(data_type,         'NUMBER'  ,data_type || ' (' ||               decode(data_precision,null,data_length || ')',                      data_precision || ',' || data_scale || ')' ),         'DATE'    ,data_type,         'LONG'    ,data_type,         'LONG RAW',data_type,         'ROWID'   ,data_type,         'MLSLABEL',data_type,           data_type || ' (' || data_length || ')' ) type,       decode(nullable,         'N','NOT NULL',         'n','NOT NULL',           NULL) pnull,      (select col2.position from dba_cons_columns col2         where col2.owner           = 'UNIMED'           and col2.table_name      = 'ACAOAUDITORIALIBERACAO'           and col2.column_name     = col1.column_name           and col2.constraint_name = (select cons.constraint_name from dba_constraints cons                                         where cons.owner           = 'UNIMED'                                           and cons.table_name      = 'ACAOAUDITORIALIBERACAO'                                           and cons.constraint_type = 'P')) PK,       data_default DEFAULT_VALUE,      (select comments from dba_col_comments comm         where comm.owner       = 'UNIMED'           and comm.table_name  = 'ACAOAUDITORIALIBERACAO'           and comm.column_name = col1.column_name) COMENTARIO  from dba_tab_columns col1  where owner      = 'UNIMED'    and table_name = 'ACAOAUDITORIALIBERACAO'
order by column_id

--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Defaults)
select column_id,column_name,data_default  from dba_tab_columns  where owner        = 'UNIMED'    and table_name   = 'ACAOAUDITORIALIBERACAO'    and data_default is not null  order by column_name


--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Indices)
select index_name,tablespace_name,uniqueness,status,logging,       initial_extent,next_extent,max_extents,pct_increase,       index_type,table_type,degree,instances,last_analyzed  from dba_indexes  where owner      = 'UNIMED'    and table_name = 'ACAOAUDITORIALIBERACAO'  order by index_name

select column_position,substr(column_name,1,60) ncolumn  from dba_ind_columns  where index_owner = 'UNIMED'    and table_name  = 'ACAOAUDITORIALIBERACAO'    and index_name  = 'IX_FK_ACAOAUD_FUNC001'  order by column_position

--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Colunas X Indices)
select substr(column_name,1,60) ncolumn,index_name,column_position  from dba_ind_columns  where index_owner = 'UNIMED'    and table_name  = 'ACAOAUDITORIALIBERACAO'
order by NCOLUMN,column_position


--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Constraints)
select c.constraint_name,       decode(c.constraint_type,'C','Check',                                'P','Primary Key',                                'U','Unique Key',                                'R','Referential') ctype,       r.owner rowner,r.table_name rtable,r.constraint_name rconstr,       c.search_condition,c.status,c.deferrable,c.deferred,       c.validated,c.generated,c.last_change  from dba_constraints c,dba_constraints r  where c.owner               = 'UNIMED'    and c.table_name          = 'ACAOAUDITORIALIBERACAO'    and r.owner           (+) = c.r_owner    and r.constraint_name (+) = c.r_constraint_name  order by constraint_name

select substr(column_name,1,60) cname from dba_cons_columns  where owner           = 'UNIMED'    and table_name      = 'ACAOAUDITORIALIBERACAO'    and constraint_name = 'FK_ACAOAUD_FUNC001'  order by position

--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Trigger)
select owner,trigger_name,trigger_type,triggering_event,status  from dba_triggers  where owner       = 'UNIMED'    and table_owner = 'UNIMED'    and table_name  = 'ACAOAUDITORIALIBERACAO'  order by trigger_name


--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Grants)
select grantee,null coluna,grantor,privilege,grantable  from dba_tab_privs  where owner      = 'UNIMED'    and table_name = 'ACAOAUDITORIALIBERACAO'union select grantee,column_name coluna,grantor,privilege,grantable  from dba_col_privs  where owner      = 'UNIMED'    and table_name = 'ACAOAUDITORIALIBERACAO'  order by 1


--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Integridade)
select r_constraint_name,owner,table_name,constraint_name,status  from all_constraints  where r_owner = 'UNIMED'    and r_constraint_name in       (select cons2.constraint_name from all_constraints cons2          where cons2.owner      = 'UNIMED'            and cons2.table_name = 'ACAOAUDITORIALIBERACAO')  order by r_constraint_name,owner,table_name,constraint_name

--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Dependencias)->(Faz Referencia)
select referenced_owner,referenced_type,referenced_name  from dba_dependencies  where owner                 = 'UNIMED'    and name                  = 'ACAOAUDITORIALIBERACAO'    and referenced_owner not in ('SYS','PUBLIC')    and referenced_type       <> 'NON-EXISTENT'  order by referenced_owner,referenced_type,referenced_name

--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Dependencias)->(É refenciada por)
select owner,type,name  from dba_dependencies  where referenced_owner = 'UNIMED'    and referenced_name  = 'ACAOAUDITORIALIBERACAO'  order by owner,type,name

--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Dados)
Listar dados da Tabela Selecionada

--- Query (Objetos dos esquemas)->(Esquema)->(Tabelas)->(Outras Informações)
select tab.tablespace_name,tab.logging,tab.initial_extent,tab.next_extent,       tab.max_extents,tab.pct_increase,tab.degree,tab.instances,       tab.last_analyzed,obj.created,obj.last_ddl_time,obj.status  from dba_tables tab,dba_objects obj  where tab.owner       = 'UNIMED'    and tab.table_name  = 'ACAOAUDITORIALIBERACAO'    and obj.owner       = tab.owner    and obj.object_type = 'TABLE'    and obj.object_name = tab.table_name

--- Query (Objetos dos esquemas)->(Esquema)->(Colunas)
--- Query (Objetos dos esquemas)->(Esquema)->(Colunas)->(Tabelas/Views)
select owner,table_name,       decode(data_type,'NUMBER'  ,data_type || ' (' ||                          decode(data_precision,null,data_length || ')',                          data_precision || ',' || data_scale || ')' ),                        'DATE'    ,data_type,                        'LONG'    ,data_type,                        'LONG RAW',data_type,                        'ROWID'   ,data_type,                        'MLSLABEL',data_type,                          data_type || ' (' || data_length || ')' ) type,       decode(nullable, 'N','NOT NULL',                        'n','NOT NULL',NULL) pnull,       column_id,data_default   from dba_tab_columns
   where owner      is not null     and column_name = 'A'   order by table_name

--- Query (Objetos dos esquemas)->(Esquema)->(Colunas)->(Indicies)
select index_owner,table_name,index_name,column_position,descend  from dba_ind_columns  where index_owner is not null    and column_name = 'A'  order by table_name,index_name

--- Query (Objetos dos esquemas)->(Esquema)->(Colunas)->(Constraints)
select col.constraint_name,col.owner,col.table_name,       decode(cons.constraint_type,'C','Check',                                   'P','Primary Key',                                   'U','Unique Key',                                   'R','Referential') ctype,       cons.search_condition,col.position  from dba_cons_columns col,dba_constraints cons
  where col.owner           is not null    and col.column_name      = 'A'    and cons.owner           = col.owner    and cons.constraint_name = col.constraint_name  order by col.table_name,col.constraint_name


--- Query (Objetos dos esquemas)->(Esquema)->(Views)  
--- Query (Objetos dos esquemas)->(Esquema)->(Views)->(Colunas)
select column_id,column_name,       decode(data_type,         'NUMBER'  ,data_type || ' (' ||               decode(data_precision,null,data_length || ')',                      data_precision || ',' || data_scale || ')' ),         'DATE'    ,data_type,         'LONG'    ,data_type,         'LONG RAW',data_type,         'ROWID'   ,data_type,         'MLSLABEL',data_type,           data_type || ' (' || data_length || ')' ) type,       decode(nullable,         'N','NOT NULL',         'n','NOT NULL',           NULL) pnull  from dba_tab_columns  where owner      = 'SYS'    and table_name = '_ACTUAL_EDITION_OBJ'
order by column_id

--- Query (Objetos dos esquemas)->(Esquema)->(Views)->(Grants)
select grantee,grantor,privilege,grantable  from dba_tab_privs  where owner      = 'SYS'    and table_name = '_ACTUAL_EDITION_OBJ'  order by grantee

--- Query (Objetos dos esquemas)->(Esquema)->(Views)->(Dependencias)->(Faz Referencia)
select referenced_owner,referenced_type,referenced_name  from dba_dependencies  where owner                 = 'SYS'    and name                  = '_ACTUAL_EDITION_OBJ'    and referenced_owner not in ('SYS','PUBLIC')    and referenced_type       <> 'NON-EXISTENT'  order by referenced_owner,referenced_type,referenced_name

--- Query (Objetos dos esquemas)->(Esquema)->(Views)->(Dependencias)->(É Referenciada por)
select owner,type,name  from dba_dependencies  where referenced_owner = 'SYS'    and referenced_name  = '_ACTUAL_EDITION_OBJ'  order by owner,type,name

--- Query (Objetos dos esquemas)->(Esquema)->(Views)->(Dados)

--- Query (Objetos dos esquemas)->(Esquema)->(Views)->(Texto)
select text from dba_views  where owner     = 'SYS'    and view_name = '_ACTUAL_EDITION_OBJ'

--- Query (Objetos dos esquemas)->(Esquema)->(Indices)  
select index_name,table_name,owner,tablespace_name,uniqueness,       status,index_type,logging,degree,instances,last_analyzed,       initial_extent,next_extent,max_extents,pct_increase  from dba_indexes
  where owner is not null
order by index_name

--- Query (Objetos dos esquemas)->(Esquema)->(Constraints)  
select c.constraint_name,       decode(c.constraint_type,'C','Check',                                'P','Primary Key',                                'U','Unique Key',                                'R','Referential') ctype,       r.owner rowner,r.table_name rtable,r.constraint_name rconstraint,       c.owner,c.table_name,c.search_condition,c.status,c.deferrable,       c.deferred,c.validated,c.generated,c.last_change  from dba_constraints c,dba_constraints r
  where c.owner              is not null    and r.owner           (+) = c.r_owner    and r.constraint_name (+) = c.r_constraint_name
order by constraint_name

--- Query (Objetos dos esquemas)->(Esquema)->(Trigger)  
--- Query (Objetos dos esquemas)->(Esquema)->(Trigger)->(Dependencias)->(Faz Referencia) 
select referenced_owner,referenced_type,referenced_name  from dba_dependencies  where owner                 = 'DBAUNIMED'    and name                  = 'A_ACAO_JUDICIAL'    and referenced_owner not in ('SYS','PUBLIC')    and referenced_type       <> 'NON-EXISTENT'  order by referenced_owner,referenced_type,referenced_name

--- Query (Objetos dos esquemas)->(Esquema)->(Trigger)->(Dependencias)->(É Referenciada por)  
select owner,type,name  from dba_dependencies  where referenced_owner = 'DBAUNIMED'    and referenced_name  = 'A_ACAO_JUDICIAL'  order by owner,type,name

--- Query (Objetos dos esquemas)->(Esquema)->(Trigger)->(Fonte)  
select description,when_clause,trigger_body from dba_triggers  where owner        = 'DBAUNIMED'    and trigger_name = 'A_ACAO_JUDICIAL'

--- Query (Objetos dos esquemas)->(Esquema)->(Trigger)->(Outras Informações)  
select trg.trigger_name,trg.trigger_type,trg.table_name,trg.owner,       trg.triggering_event,trg.status,obj.created,obj.last_ddl_time  from dba_triggers trg,dba_objects obj  where trg.owner        = 'DBAUNIMED'    and trg.trigger_name = 'A_ACAO_JUDICIAL'    and obj.owner        = trg.owner    and obj.object_type  = 'TRIGGER'    and obj.object_name  = trg.trigger_name

--- Query (Objetos dos esquemas)->(Esquema)->(Grants)->(Previlegios do Sistema)
select grantee,privilege,admin_option  from dba_sys_privs  where not exists (select 1 from dba_roles                      where role = grantee)  order by privilege

--- Query (Objetos dos esquemas)->(Esquema)->(Grants)->(Previlegios em Atribuicoes)  
select grantee,granted_role,admin_option  from dba_role_privs  where not exists (select 1 from dba_roles                      where role = grantee)  order by granted_role

--- Query (Objetos dos esquemas)->(Esquema)->(Grants)->(Previlegios em Objetos)  
select grantee,owner,table_name,null coluna,privilege,grantor  from dba_tab_privs   where not exists (select 1 from dba_roles                      where role = grantee)union select grantee,owner,table_name,column_name coluna,privilege,grantor  from dba_col_privs  where not exists (select 1 from dba_roles                      where role = grantee)  order by 1,2,3,4

--- Query (Objetos dos esquemas)->(Esquema)->(Packges)  
--- Query (Objetos dos esquemas)->(Esquema)->(Packges)->(Grants)
select grantee,grantor,privilege,grantable  from dba_tab_privs  where owner      = 'EXFSYS'    and table_name = 'ADM_EXPFIL_SYSTRIG'  order by grantee

--- Query (Objetos dos esquemas)->(Esquema)->(Packges)->(Dependencias)->(Faz Referencia) 
select referenced_owner,referenced_type,referenced_name  from dba_dependencies  where owner                 = 'EXFSYS'    and name                  = 'ADM_EXPFIL_SYSTRIG'    and referenced_owner not in ('SYS','PUBLIC')    and referenced_type       <> 'NON-EXISTENT'  order by referenced_owner,referenced_type,referenced_name

--- Query (Objetos dos esquemas)->(Esquema)->(Packges)->(Dependencias)->(É Referenciada por)  
select owner,type,name  from dba_dependencies  where referenced_owner = 'EXFSYS'    and referenced_name  = 'ADM_EXPFIL_SYSTRIG'  order by owner,type,name

--- Query (Objetos dos esquemas)->(Esquema)->(Packges)->(Fonte)
select text text_package from dba_source  where owner = 'EXFSYS'    and name  = 'ADM_EXPFIL_SYSTRIG'    and type  = 'PACKAGE BODY'  order by LINE

--- Query (Objetos dos esquemas)->(Esquema)->(Packges)->(Outras Informações)
select owner,object_name,created,last_ddl_time,status  from dba_objects  where owner       = 'EXFSYS'    and object_name = 'ADM_EXPFIL_SYSTRIG'

--- Query (Objetos dos esquemas)->(Esquema)->(Procedures)  
--- Query (Objetos dos esquemas)->(Esquema)->(Procedures)->(Grants)
select grantee,grantor,privilege,grantable  from dba_tab_privs  where owner      = 'APEX_030200'    and table_name = 'APEX'  order by grantee

--- Query (Objetos dos esquemas)->(Esquema)->(Procedures)->(Dependencias)->(Faz Referencia)  
select referenced_owner,referenced_type,referenced_name  from dba_dependencies  where owner                 = 'APEX_030200'    and name                  = 'APEX'    and referenced_owner not in ('SYS','PUBLIC')    and referenced_type       <> 'NON-EXISTENT'  order by referenced_owner,referenced_type,referenced_name

--- Query (Objetos dos esquemas)->(Esquema)->(Procedures)->(Dependencias)->(É Referenciada por)   
select owner,type,name  from dba_dependencies  where referenced_owner = 'APEX_030200'    and referenced_name  = 'APEX'  order by owner,type,name

--- Query (Objetos dos esquemas)->(Esquema)->(Procedures)->(Fonte)  
select text text_procedure from dba_source  where owner = 'APEX_030200'    and name  = 'APEX'    and type  = 'PROCEDURE'

--- Query (Objetos dos esquemas)->(Esquema)->(Procedures)->(Outras Informações)  
select owner,object_name,created,last_ddl_time,status  from dba_objects  where owner       = 'APEX_030200'    and object_name = 'APEX'

--- Query (Objetos dos esquemas)->(Esquema)->(Functions)  
--- Query (Objetos dos esquemas)->(Esquema)->(Functions)->(Grants) 
select grantee,grantor,privilege,grantable  from dba_tab_privs  where owner      = 'DBAUNIMED'    and table_name = 'ACOMODACAO'  order by grantee

--- Query (Objetos dos esquemas)->(Esquema)->(Functions)->(Dependencias)->(Faz Referencia) 
select referenced_owner,referenced_type,referenced_name  from dba_dependencies  where owner                 = 'DBAUNIMED'    and name                  = 'ACOMODACAO'    and referenced_owner not in ('SYS','PUBLIC')    and referenced_type       <> 'NON-EXISTENT'  order by referenced_owner,referenced_type,referenced_name

--- Query (Objetos dos esquemas)->(Esquema)->(Functions)->(Dependencias)->(É Referenciada por) 
select owner,type,name  from dba_dependencies  where referenced_owner = 'DBAUNIMED'    and referenced_name  = 'ACOMODACAO'  order by owner,type,name

--- Query (Objetos dos esquemas)->(Esquema)->(Functions)->(Fonte)  
select text text_function from dba_source  where owner = 'DBAUNIMED'    and name  = 'ACOMODACAO'    and type  = 'FUNCTION'

--- Query (Objetos dos esquemas)->(Esquema)->(Functions)->(Outras Informações)  
select owner,object_name,created,last_ddl_time,status  from dba_objects  where owner       = 'DBAUNIMED'    and object_name = 'ACOMODACAO'


--- Query (Objetos dos esquemas)->(Esquema)->(Sequences)  
select * from dba_sequences  where sequence_owner is not null
  order by sequence_name,sequence_owner

--- Query (Objetos dos esquemas)->(Esquema)->(Synonyms)  
select * from dba_synonyms  where owner is not null
order by owner,synonym_name

--- Query (Objetos dos esquemas)->(Esquema)->(Jobs)  
select * from dba_jobs  order by schema_user,job


--- Query (Objetos dos esquemas)->(Public)
--- Query (Objetos dos esquemas)->(Public)->(Synonym)
select * from dba_synonyms  where owner = 'PUBLIC'
order by synonym_name

--- Query (Objetos dos esquemas)->(Public)->(Database Links)
select * from dba_db_links  where owner = 'PUBLIC'  order by db_link


-- Menu: Instância->Perfis
--- Query (Perfis)->(Informações)  
--- Query (Perfis)->(Informações)->(Recursos)
select resource_name,resource_type,limit from dba_profiles   where profile = :PROFILE  order by resource_name

--- Query (Perfis)->(Informações)->(Usúarios)  
select username from dba_users   where profile = :PROFILE   order by username


-- Menu: Instância->Usuários
--- Query (Usuários)->(Informações)->(Tablespace) 
select username,default_tablespace,temporary_tablespace,account_status,       created,lock_date,expiry_date,profile from dba_users
  order by username

--- Query (Usuários)->(Informações)->(Datas)  
select username,default_tablespace,temporary_tablespace,account_status,       created,lock_date,expiry_date,profile from dba_users
  order by username

--- Query (Usuários)->(Informações)->(Perfil)  
select tablespace_name,bytes / 1024 quota from dba_ts_quotas
  where username = :USERNAME
  order by tablespace_name

--- Query (Usuários)->(Informações)->(Quotas)  
select tablespace_name,bytes / 1024 quota from dba_ts_quotas
  where username = :USERNAME
  order by tablespace_name


-- Menu: Instância->Usuários e Atribuições
--- Query (Usuários e Atribuições)->(Usuario)  
--- Query (Usuários e Atribuições)->(Usuario)->(Previlégios de Sistema)
select privilege,admin_option  from dba_sys_privs  where grantee = 'ADELMO'  order by privilege

--- Query (Usuários e Atribuições)->(Usuario)->(Previlégios em Atribuições)  
select granted_role,admin_option  from dba_role_privs  where grantee = 'ADELMO'  order by granted_role

--- Query (Usuários e Atribuições)->(Usuario)->(Previlégios em Objetos)  
select owner,table_name,null coluna,privilege,grantor  from dba_tab_privs  where grantee = 'ADELMO'union select owner,table_name,column_name coluna,privilege,grantor  from dba_col_privs  where grantee = 'ADELMO'  order by 1,2,3,4

--- Query (Usuários e Atribuições)->(Atribuições)
--- Query (Usuários e Atribuições)->(Atribuições)->(Previlégios de Sistema)
select privilege,admin_option  from dba_sys_privs  where grantee = 'ADM_PARALLEL_EXECUTE_TASK'  order by privilege

--- Query (Usuários e Atribuições)->(Atribuições)->(Previlégios em Atribuições)
select granted_role,admin_option  from dba_role_privs  where grantee = 'ADM_PARALLEL_EXECUTE_TASK'  order by granted_role

--- Query (Usuários e Atribuições)->(Atribuições)->(Previlégios em Objetos)
select owner,table_name,null coluna,privilege,grantor  from dba_tab_privs  where grantee = 'ADM_PARALLEL_EXECUTE_TASK'union select owner,table_name,column_name coluna,privilege,grantor  from dba_col_privs  where grantee = 'ADM_PARALLEL_EXECUTE_TASK'  order by 1,2,3,4



-- Menu: Armazenamento->Control Files
--- Query (Control Files)->(Control Files) 
select substr(name,1,60) file_name,status  from v$controlfile  order by file_name
--- Query (Control Files)->(Seção de Registro) 
select * from v$controlfile_record_section  order by type

-- Menu: Armazenamento->Tablespace e Datafiles
--- Query (Tablespace e datafiles)->(Tablespace e DataFiles) 
--- Query (Tablespace e datafiles)->(Tablespace e DataFiles)->(Tablespaces) 
SELECT tablespace_name,ROUND (tssize) tbs_size_mb,ROUND (tsused) used,       ROUND ((tssize - tsused)) avail,ROUND ((tsused / tssize) * 100,2) pct_used,max_contiguous,       status,LOGGING,extent_type extent_management,CONTENTS,initial_extent,next_extent,       min_extents,max_extents,pct_increase  FROM (SELECT d.status, d.tablespace_name, d.CONTENTS,               d.extent_management extent_type, d.LOGGING,d.initial_extent,               d.next_extent,d.min_extents,d.max_extents,d.pct_increase,               d.allocation_type, (a.BYTES / 1024 / 1024) tssize,              (a.maxbytes / 1024 / 1024) tsmaxsize,               NVL (a.BYTES - NVL (f.BYTES, 0), 0) / 1024 / 1024 tsused,               ROUND (NVL (f.MAX_CONT,0) / 1024 / 1024) max_contiguous          FROM SYS.dba_tablespaces d,              (SELECT tablespace_name, SUM (BYTES) BYTES,                      SUM (maxbytes) maxbytes                 FROM dba_data_files                 GROUP BY tablespace_name) a,              (SELECT tablespace_name, SUM (BYTES) BYTES, MAX (BYTES) MAX_CONT                 FROM dba_free_space                 GROUP BY tablespace_name) f          WHERE d.tablespace_name = a.tablespace_name(+)            AND d.tablespace_name = f.tablespace_name(+)            AND NOT (d.extent_management LIKE 'LOCAL'            AND d.CONTENTS LIKE 'TEMPORARY')        UNION ALL        SELECT d.status, d.tablespace_name, d.CONTENTS,               d.extent_management extent_type, d.LOGGING,d.initial_extent,               d.next_extent,d.min_extents,d.max_extents,d.pct_increase,               d.allocation_type, (a.BYTES / 1024 / 1024) tssize,              (a.maxbytes / 1024 / 1024) tsmaxsize,               NVL ((a.BYTES - w.MAX_CONT), 0) / 1024 / 1024 tsused,               ROUND (NVL (w.MAX_CONT,0) / 1024 / 1024) max_contiguous          FROM SYS.dba_tablespaces d,              (SELECT tablespace_name, SUM (BYTES) BYTES,                      SUM (maxbytes) maxbytes                 FROM dba_temp_files                 GROUP BY tablespace_name) a,              (SELECT tablespace_name, SUM (bytes_free) MAX_CONT                 FROM v$temp_space_header                 GROUP BY tablespace_name) w          WHERE d.tablespace_name = a.tablespace_name(+)            AND d.tablespace_name = w.tablespace_name(+)            AND d.extent_management LIKE 'LOCAL'            AND d.CONTENTS LIKE 'TEMPORARY')
order by pct_used desc

--- Query (Tablespace e datafiles)->(Tablespace e DataFiles)->(Datafiles)
SELECT t.tablespace_name tablespace_name,d.file_name datafile_name,       ROUND (NVL (d.max_bytes,0) / 1024 / 1024) dtf_size_mb,       ROUND ((d.max_bytes - NVL (f.sum_bytes, 0)) / 1024 / 1024) used,       ROUND (NVL (f.sum_bytes, 0) / 1024 / 1024) avail,       ROUND ((d.max_bytes - NVL (f.sum_bytes, 0)) / NVL (d.max_bytes,0) * 100,2) pct_used,       d.status,z.status backup,t.initial_extent,t.next_extent,       t.min_extents, t.max_extents,t.pct_increase,d.file_id  FROM (SELECT tablespace_name, file_id, SUM (BYTES) sum_bytes          FROM dba_free_space          GROUP BY tablespace_name, file_id) f,       (SELECT tablespace_name, file_name, file_id, MAX (BYTES) max_bytes,status          FROM dba_data_files          GROUP BY tablespace_name, file_name, file_id, status) d,        dba_tablespaces t,v$backup z  WHERE d.tablespace_name    = 'TEMP'    AND t.tablespace_name    = d.tablespace_name    AND f.tablespace_name(+) = d.tablespace_name    AND f.file_id(+)         = d.file_id    AND z.file#              = d.file_id  GROUP BY t.tablespace_name,d.file_name,d.file_id,z.status,t.initial_extent,t.next_extent,           t.min_extents,t.max_extents,t.pct_increase,d.max_bytes,f.sum_bytes,d.status UNION ALL SELECT h.tablespace_name,t.file_name datafile_name,       ROUND (SUM (h.bytes_free + h.bytes_used) / 1048576) dtf_size_mb,       ROUND (SUM (NVL (p.bytes_cached, 0)) / 1048576) used,       ROUND (SUM ((h.bytes_free + h.bytes_used) - NVL (p.bytes_cached, 0)) / 1048576) avail,       ROUND (SUM (NVL (p.bytes_cached, 0)) / SUM(h.bytes_free + h.bytes_used) * 100,2) pct_used,       t.status,'NO' backup,-1,-1,-1,-1,-1,t.file_id  FROM SYS.v_$temp_space_header h,       SYS.v_$temp_extent_pool p,       SYS.dba_temp_files t,       SYS.dba_tablespaces ts  WHERE h.tablespace_name    = 'TEMP'    AND p.file_id(+)         = h.file_id    AND p.tablespace_name(+) = h.tablespace_name    AND h.file_id            = t.file_id    AND h.tablespace_name    = t.tablespace_name    AND ts.tablespace_name   = h.tablespace_name  GROUP BY h.tablespace_name, t.status, t.file_name, t.file_id  ORDER BY 1,2

--- Query (Tablespace e datafiles)->(ASM) 
--- Query (Tablespace e datafiles)->(ASM)->(Grupos de Discos) 
select 1 x,group_number,name,type,state,sector_size,block_size,offline_disks,
       total_mb,(total_mb - free_mb) ocup_mb,free_mb,
     ((total_mb - free_mb) / total_mb) * 100 pct_used
  from v$asm_diskgroup
union
select 2 x,null,'TOTAL','==========','=========>',null,null,null,
       sum(total_mb),sum(total_mb - free_mb),sum(free_mb),
      (sum(total_mb - free_mb) / sum(total_mb)) * 100
  from v$asm_diskgroup
order by x

--- Query (Tablespace e datafiles)->(ASM)->(Discos) 
select group_number,name,path,state,reads,(bytes_read / 1024) / 1024 bytes_read,
       writes,(bytes_written / 1024) / 1024 bytes_written,total_mb,
      (total_mb - free_mb) ocup_mb,free_mb,
     ((total_mb - free_mb) / total_mb) * 100 pct_used
  from v$asm_disk
  where group_number = :GROUP_NUMBER


--- Query (Tablespace e datafiles)->(Percentuais de I/O)
select tab.name tablespace,substr(dat.name,1,60) datafile,       dat.bytes/1024/1024 TAM_DTF,       sta.phywrts,sta.phyrds,      (sta.phywrts + sta.phyrds) TOTAL_IO,     ((sta.phywrts + sta.phyrds) /      (select sum(sta2.phywrts + sta2.phyrds)         from v$filestat sta2) * 100) PERC_IO  from v$tablespace tab,v$datafile dat,v$filestat sta  where dat.ts#   = tab.ts#    and sta.file# = dat.file#
order by perc_io desc

--- Query (Tablespace e datafiles)->(Percentuais de I/O) 
select tab.name tablespace,
       sum(sta.phywrts + sta.phyrds) TOTAL_IO,
       sum((sta.phywrts + sta.phyrds) /
           (select sum(sta2.phywrts + sta2.phyrds)
              from v$filestat sta2) * 100) PERC_IO
  from v$tablespace tab,v$datafile dat,v$filestat sta
  where dat.ts#   = tab.ts#
    and sta.file# = dat.file#
  group by tab.name
  order by perc_io desc

--- Query (Tablespace e datafiles)->(Percentuais de I/O) 
select substr(substr(dat.name,1,instr(dat.name,'/',1,
      (length(dat.name) - length(replace(dat.name,'/',''))))),1,60) VOLUME,
       sum(sta.phywrts + sta.phyrds) TOTAL_IO,
       sum((sta.phywrts + sta.phyrds) /
           (select sum(sta2.phywrts + sta2.phyrds)
              from v$filestat sta2) * 100) PERC_IO
  from v$tablespace tab,v$datafile dat,v$filestat sta
  where dat.ts#   = tab.ts#
    and sta.file# = dat.file#
  group by substr(substr(dat.name,1,instr(dat.name,'/',1,
          (length(dat.name) - length(replace(dat.name,'/',''))))),1,60)
  order by perc_io desc

--- Query (Tablespace e datafiles)->(Fragmentação) 
--- Query (Tablespace e datafiles)->(Fragmentação)->(Tablespace)
select tablespace_name,count(*) extents  from dba_free_space  group by tablespace_name
order by extents desc

--- Query (Tablespace e datafiles)->(Fragmentação)->(Segmentos) 
--- Query (Tablespace e datafiles)->(Fragmentação)->(Segmentos)->(por Segmento) 
select segment_name,segment_type,owner,tablespace_name,extents  from dba_segments
order by extents desc

--- Query (Tablespace e datafiles)->(Fragmentação)->(Segmentos)->(por Tablespace) 
select segment_name,segment_type,owner,tablespace_name,extents  from dba_segments
order by extents desc

--- Query (Tablespace e datafiles)->(Fragmentação)->(Segmentos)->(por Usuário)
select segment_name,segment_type,owner,tablespace_name,extents  from dba_segments
order by extents desc
  
--- Query (Tablespace e datafiles)->(Extents) 
select /*+ RULE */ ext.segment_name,ext.segment_type,ext.owner,       dtf.tablespace_name,       substr(dtf.file_name,1,60) datafile_name  from dba_extents ext,dba_data_files dtf  where dtf.file_id = ext.file_id
order by segment_name

--- Query (Tablespace e datafiles)->(Mais Informações) 
--- Query (Tablespace e datafiles)->(Mais Informações)->(Segmentos com mais de 90% dos extents utilizados)
select ((extents / max_extents) * 100) perc,         extents,max_extents,owner,segment_name,         segment_type,tablespace_name  from dba_segments  where   max_extents > 0    and ((extents / max_extents) * 100) > 90  order by segment_name

--- Query (Tablespace e datafiles)->(Mais Informações)->(Segmentos que não podem extender)
select /*+ RULE */ a.owner,a.segment_name,a.segment_type,b.tablespace_name,       decode(ext.extents,1,b.next_extent, a.bytes*(1+b.pct_increase/100)) nextext,       freesp.largest  from dba_extents a,dba_segments b,      (select owner,segment_name,max(extent_id) extent_id,              count(*) extents         from dba_extents         group by owner,segment_name) ext,      (select tablespace_name,max(bytes) largest         from dba_free_space         group by tablespace_name) freesp  where a.owner           = b.owner    and a.segment_name    = b.segment_name    and a.owner           = ext.owner    and a.segment_name    = ext.segment_name    and a.extent_id       = ext.extent_id    and b.tablespace_name = freesp.tablespace_name    and decode(ext.extents,1,b.next_extent, a.bytes*(1+b.pct_increase/100)) > freesp.largest  order by a.segment_name

--- Query (Tablespace e datafiles)->(Mais Informações)->(tablespace offline)
select tablespace_name from dba_tablespaces  where status <> 'ONLINE'  order by tablespace_name

--- Query (Tablespace e datafiles)->(Mais Informações)->(Datafiles indisponíveis)
select substr(dtf.file_name,1,60) datafile_name,       dtf.tablespace_name,dtf.status,bac.status backup  from v$backup bac,dba_data_files dtf  where  bac.file#   = dtf.file_id    and (dtf.status <> 'AVAILABLE'     or  bac.status <> 'NOT ACTIVE')  order by datafile_name



-- Menu: Armazenamento->Seguimentos de Rollback
--- Query (Segmentos de Rollback) 
--- Query (Segmentos de Rollback)->(Segmentos de Rollback) 
select seg.*,sta.extents,(sta.rssize / 1024) roll_size  from dba_rollback_segs seg,v$rollname nam,v$rollstat sta  where nam.name = seg.segment_name    and sta.usn  = nam.usn  order by seg.segment_name

--- Query (Segmentos de Rollback)->(Transações Ativas) 
select s.username,s.sid,s.serial#,s.osuser,t.xidusn,t.ubafil,       t.ubablk,t.used_ublk  from v$session s,v$transaction t  where s.saddr = t.ses_addr  order by s.username


-- Menu: Armazenamento->Redo logs
--- Query (Redo Logs) 
--- Query (Redo Logs)->(Informações)
select group#,sequence#,(bytes / 1024) redo_size,members,status  from v$log  order by group#

--- Query (Redo Logs)->(Informações) 
select substr(member,1,60) member_name,status  from v$logfile  where group# = 1  order by member_name


-- Menu: Armazenamento->Archives
--- Query (Archive)
--- Query (Archive)->(Informações)
select substr(name,1,60) arch_name,first_change#,first_time,       completion_time,archived,deleted  from v$archived_log  order by sequence# desc


-- Menu: Performace
--- Query (Parametros de Performace)->(Parametros)  
--- Query (Parametros de Performace)->(Parametros)->(SGA) 
select 2 x,pool,name,bytes from v$sgastat
union
select 1 x,'TOTAL SGA' POOL,'---------------------->' NAME,sum(bytes) from v$sgastat
  order by x 
 
--- Query (Parametros de Performace)->(Parametros)->(SGA)  
select 1 x,'LIBRARY CACHE - SQL AREA' ITEM,round(gethitratio * 100,4) VALOR,
      (case when round(gethitratio * 100,4) > 90 then 'Normal' else 'Nível de alerta!' end) SITUACAO,
       'Deve ser maior que 90%, caso contrário verifique a necessidade de aumentar o valor do parâmetro SHARED_POOL_SIZE.' COMENTARIO
  from v$librarycache
  where namespace = 'SQL AREA'
union
select 2 x,'LIBRARY CACHE - RELOADS/PINS' ITEM,trunc(sum(reloads)/sum(pins) * 100,4) VALOR,
      (case when trunc(sum(reloads)/sum(pins) * 100,4) < 1 then 'Normal' else 'Nível de alerta!' end) SITUACAO,
       'Deve ser menor que 1%, caso contrário verifique a necessidade de aumentar o valor do parâmetro SHARED_POOL_SIZE.' COMENTARIO
  from v$librarycache
union
select 3 x,'DATA DICTIONARY CACHE' ITEM,trunc(sum(getmisses)/sum(gets) * 100,4) VALOR,
      (case when trunc(sum(getmisses)/sum(gets) * 100,4) < 15 then 'Normal' else 'Nível de alerta!' end) SITUACAO,
       'Deve ser menor que 15%, caso contrário verifique a necessidade de aumentar o valor do parâmetro SHARED_POOL_SIZE.' COMENTARIO
  from v$rowcache
union
select 4 x,'DATABASE BUFFER CACHE - HIT RATIO' ITEM,trunc((1 - (phy.value / (cur.value + con.value))) * 100,4) VALOR,
      (case when trunc((1 - (phy.value / (cur.value + con.value))) * 100,4) > 90 then 'Normal' else 'Nível de alerta!' end) SITUACAO,
       'Deve ser maior que 90%, caso contrário verifique a necessidade de aumentar o valor do parâmetro DB_BLOCK_BUFFERS.' COMENTARIO
  from v$sysstat cur,v$sysstat con,v$sysstat phy
  where cur.name = 'db block gets from cache'
    and con.name = 'consistent gets from cache'
    and phy.name = 'physical reads cache'
union
select 5 x,'DATABASE BUFFER CACHE - LRU LATCH' ITEM,trunc(sleeps / gets * 100, 4) VALOR,
      (case when trunc(sleeps / gets * 100, 4) < 1 then 'Normal' else 'Nível de alerta!' end) SITUACAO,
       'Deve ser menor que 1%, caso contrário verifique a necessidade de aumentar o valor do parâmetro DB_BLOCK_LRU_LATCHES.' COMENTARIO
  from v$latch
  where name = 'cache buffers lru chain'
union
select 6 x,'REDO LOG BUFFER - REQUESTS/ENTRIES' ITEM,trunc(req.value / ent.value * 100, 4) VALOR,
      (case when trunc(req.value / ent.value * 100, 4) < 1 then 'Normal' else 'Nível de alerta!' end) SITUACAO,
       'Deve ser menor que 1%, caso contrário verifique a necessidade de aumentar o valor do parâmetro LOG_BUFFER.' COMENTARIO
  from v$sysstat ent, v$sysstat req
  where req.name = 'redo log space requests'
    and ent.name = 'redo entries'
order by x


--- Query (Parametros de Performace)->(Parametros)->(Disputas Rollback)  
select 'Disputas por cabeçalhos de rollback' Name,
       (sum(waits) * 100) / sum(gets) Ratio,
       'Deve ser inferior a 5%, caso contrário analise a possibilidade de criar mais segmentos de rollback.' Comments
  from v$rollstat
union
select 'Disputas por segmentos de rollback - ' || cla.class Name,
       (cla.count * 100) / sta.value Ratio,
       'Deve ser inferior a 1%, caso contrário analise a possibilidade de criar mais segmentos de rollback.' Comments
  from v$waitstat cla,v$sysstat sta
  where sta.name = 'consistent gets'
    and cla.class like '%undo%'
  order by 1
 
 
--- Query (Parametros de Performace)->(Parametros)->(Varreduras Integrais)  
select name,value from v$sysstat
  where name like '%table scans%'

--- Query (Parametros de Performace)->(Parametros)->(Proporção de Ordenação disco x memória(%))  
select (disk.value / mem.value) * 100 "Ratio",
       'Deve ser inferior a 5%, caso contrário verifique a necessidade de aumentar o valor do parâmetro SORT_AREA_SIZE.' Comments
  from v$sysstat mem, v$sysstat disk
  where mem.name = 'sorts (memory)'
    and disk.name = 'sorts (disk)'
 
--- Query (Parametros de Performace)->(Consumo de Recursos)
select resource_name,current_utilization,max_utilization,initial_allocation,
       limit_value,
       case when initial_allocation <> ' UNLIMITED'
             and max_utilization >= initial_allocation then 'ATENÇÃO'
       else 'Normal'
       end situacao
  from v$resource_limit
  order by resource_name


-- Menu: Ferramentas->Instruções SQL :F6

--- Query ()  
--- Query ()  
--- Query ()  
--- Query ()  