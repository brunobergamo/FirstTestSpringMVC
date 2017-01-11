================================================================
					IXCOLDEV - APPDEV
================================================================
--CREATE TABLE "APPDEV"."IXC_MAIL_LETTER"
--(
--	"SEQNO" NUMBER(*,0),
--	"EMAIL" VARCHAR2(80),
--	"SUBJECT" VARCHAR2(100),
--	"MESSAGE" VARCHAR2(300),
--	"FILENAME" VARCHAR2(50),
--	"CUSTNUM" VARCHAR2(30),
--	"AMOUNT" FLOAT(126),
--	"CREATED_DATE" DATE,
--	"UPDATED_DATE" DATE,
--	"STATUS" CHAR(1),
--	"LETTER_CREATED" CHAR(1)
--)
--TABLESPACE "DATA";

--CREATE SEQUENCE IXC_MAIL_LETTER_SEQ
--START WITH     1
--INCREMENT BY   1
--NOCACHE
--NOCYCLE;
----------------------------------------------------------------
SELECT
	*
FROM
	IXC_MAIL_LETTER;
----------------------------------------------------------------
================================================================
					IXCOLDEV - SYSADM
================================================================
SELECT
	*
FROM
	WMSADM.WORKFLOW_ENTITY
WHERE
	UPPER(ATTR_STRING_7_VALUE) LIKE 'CONSUMER%'
	AND UPPER(LAST_ACTIVITY) LIKE 'SUSPEND%'
	AND trunc(LAST_ACTIVITY_DATE) = trunc(SYSDATE);
----------------------------------------------------------------
================================================================
							BSCSDB
================================================================
SELECT
	cua.custnum,
	cua.customer_id,
	decode(ctoa.cctitle,1,'M',2,'F','M') gender,
	ctoa.ccfname,
	ctoa.cclname,
	ctoa.cctn,
	ctoa.ccemail,
	ctra.co_code as co_code,
	upper(cus.ch_status) as co_status,
	cua.business_unit_id,
	rp.shdes as rp_code,
	sp.shdes as sp_code,
	sn.shdes as sn_code,
	upper(psnh.status) as sn_status,
	dn.dn_id,
	dn.dn_num
FROM
	customer_all cua,
	ccontact_all ctoa,
	contract_all ctra,
	curr_co_status cus,
	profile_service ps,
	pr_serv_status_hist psnh,
	pr_serv_spcode_hist psph,
	mpulktmb tmb,
	rateplan rp,
	rateplan_version rpv,
	mpusptab sp,
	mpusntab sn,
	forcurr fc,
	(
		SELECT
			csp.co_id,
			csp.sncode,
			dn.dn_id,
			dn.dn_num
		FROM
			contr_services_cap csp,
			directory_number dn
		WHERE
			csp.dn_id = dn.dn_id AND
			csp.cs_deactiv_date IS NULL
	) dn,
	(
		SELECT
			pv.co_id,
			pv.sncode,
			mpk.prm_des,
			pv.prm_description
		FROM
			parameter_value pv,
			mkt_parameter mpk
		WHERE
			pv.sccode = mpk.sccode AND
			pv.parameter_id = mpk.parameter_id
	) pv
WHERE
	cua.custnum = '102000010004' AND
--	cua.custnum = '102000012373' AND
	ctoa.ccseq='-1' AND
	cua.customer_id = ctoa.customer_id AND
	ctoa.customer_id = ctra.customer_id AND
	ctra.co_id = cus.co_id AND
	ctra.co_id = ps.co_id AND
	ps.co_id = psnh.co_id AND
	ps.profile_id = psnh.profile_id AND
	ps.sncode = psnh.sncode AND
	ps.status_histno = psnh.histno AND
	ps.co_id = psph.co_id AND
	ps.profile_id = psph.profile_id AND
	ps.sncode = psph.sncode AND
	ps.spcode_histno = psph.histno AND
	ctra.tmcode = tmb.tmcode AND
	rpv.vscode = tmb.vscode AND
	psnh.sncode = tmb.sncode AND
	psph.spcode = tmb.spcode AND
	rpv.tmcode = rp.tmcode AND
	rpv.vscode =
	(
		SELECT
			MAX(v.vscode)
		FROM
			rateplan_version v
		WHERE
			v.tmcode = ctra.tmcode
	) AND
	ctra.tmcode = rp.tmcode AND
	psnh.sncode = sn.sncode AND
	psph.spcode = sp.spcode AND
	rpv.currency = fc.fc_id AND
	ps.co_id = dn.co_id(+) AND
	ps.sncode = dn.sncode(+) AND
	ps.co_id = pv.co_id(+) AND
	ps.sncode = pv.sncode(+) AND
	psnh.status = 'A'
--	AND ccfname IS NOT NULL
--	AND cctn IS NOT NULL
--	AND ccemail IS NOT NULL
ORDER BY
	cua.custnum,
	cua.customer_id,
	gender,
	ctoa.ccfname,
	ctoa.cclname,
	ctoa.cctn,
	ctoa.ccemail,
	ctra.co_code,
	cus.ch_status,
	cua.business_unit_id,
	rp_code,
	sp_code,
	sn_code,
	dn.dn_id,
	dn.dn_num,
	psnh.status
----------------------------------------------------------------
================================================================
							BSCSDEV
================================================================
SELECT DISTINCT
	cua.custnum,
	ctra.co_code AS co_code,
	UPPER(cus.ch_status) AS co_status,
	cua.business_unit_id
FROM
	customer_all cua,
	ccontact_all ctoa,
	contract_all ctra,
	curr_co_status cus,
	profile_service ps,
	pr_serv_status_hist psnh,
	pr_serv_spcode_hist psph,
	mpulktmb tmb,
	rateplan rp,
	rateplan_version rpv,
	mpusptab sp,
	mpusntab sn,
	forcurr fc,
	(
		SELECT
			csp.co_id,
			csp.sncode,
			dn.dn_id,
			dn.dn_num
		FROM
			contr_services_cap csp,
			directory_number dn
		WHERE
			csp.dn_id = dn.dn_id AND
			csp.cs_deactiv_date IS NULL
	) dn,
	(
		SELECT
			pv.co_id,
			pv.sncode,
			mpk.prm_des,
			pv.prm_description
		FROM
			parameter_value pv,
			mkt_parameter mpk
		WHERE
			pv.sccode = mpk.sccode AND
			pv.parameter_id = mpk.parameter_id
	) pv
WHERE
--	BSCSTEST
--	cua.custnum = '302000013920' AND
	ctra.co_code = 'CONTR0000001639' AND
	ctoa.ccseq='-1' AND
	cua.customer_id = ctoa.customer_id AND
	ctoa.customer_id = ctra.customer_id AND
	ctra.co_id = cus.co_id AND
	ctra.co_id = ps.co_id AND
	ps.co_id = psnh.co_id AND
	ps.profile_id = psnh.profile_id AND
	ps.sncode = psnh.sncode AND
	ps.status_histno = psnh.histno AND
	ps.co_id = psph.co_id AND
	ps.profile_id = psph.profile_id AND
	ps.sncode = psph.sncode AND
	ps.spcode_histno = psph.histno AND
	ctra.tmcode = tmb.tmcode AND
	rpv.vscode = tmb.vscode AND
	psnh.sncode = tmb.sncode AND
	psph.spcode = tmb.spcode AND
	rpv.tmcode = rp.tmcode AND
	rpv.vscode =
	(
		SELECT
			MAX(v.vscode)
		FROM
			rateplan_version v
		WHERE
			v.tmcode = ctra.tmcode
	) AND
	ctra.tmcode = rp.tmcode AND
	psnh.sncode = sn.sncode AND
	psph.spcode = sp.spcode AND
	rpv.currency = fc.fc_id AND
	ps.co_id = dn.co_id(+) AND
	ps.sncode = dn.sncode(+) AND
	ps.co_id = pv.co_id(+) AND
	ps.sncode = pv.sncode(+)
ORDER BY
	co_code,
	co_status,
	cua.business_unit_id
----------------------------------------------------------------
SELECT DISTINCT
	rp.shdes AS rp_code,
	sp.shdes AS sp_code,
	sn.shdes AS sn_code,
	UPPER(psnh.status) AS sn_status,
	dn.dn_id,
	dn.dn_num
FROM
	customer_all cua,
	ccontact_all ctoa,
	contract_all ctra,
	curr_co_status cus,
	profile_service ps,
	pr_serv_status_hist psnh,
	pr_serv_spcode_hist psph,
	mpulktmb tmb,
	rateplan rp,
	rateplan_version rpv,
	mpusptab sp,
	mpusntab sn,
	forcurr fc,
	(
		SELECT
			csp.co_id,
			csp.sncode,
			dn.dn_id,
			dn.dn_num
		FROM
			contr_services_cap csp,
			directory_number dn
		WHERE
			csp.dn_id = dn.dn_id AND
			csp.cs_deactiv_date IS NULL
	) dn,
	(
		SELECT
			pv.co_id,
			pv.sncode,
			mpk.prm_des,
			pv.prm_description
		FROM
			parameter_value pv,
			mkt_parameter mpk
		WHERE
			pv.sccode = mpk.sccode AND
			pv.parameter_id = mpk.parameter_id
	) pv
WHERE
--	BSCSTEST
--	cua.custnum = 'CUST0000000030' AND
--	cua.custnum = '302000013920' AND
	cua.custnum = 'CUST0000000161' AND
	ctoa.ccseq='-1' AND
	cua.customer_id = ctoa.customer_id AND
	ctoa.customer_id = ctra.customer_id AND
	ctra.co_id = cus.co_id AND
	ctra.co_id = ps.co_id AND
	ps.co_id = psnh.co_id AND
	ps.profile_id = psnh.profile_id AND
	ps.sncode = psnh.sncode AND
	ps.status_histno = psnh.histno AND
	ps.co_id = psph.co_id AND
	ps.profile_id = psph.profile_id AND
	ps.sncode = psph.sncode AND
	ps.spcode_histno = psph.histno AND
	ctra.tmcode = tmb.tmcode AND
	rpv.vscode = tmb.vscode AND
	psnh.sncode = tmb.sncode AND
	psph.spcode = tmb.spcode AND
	rpv.tmcode = rp.tmcode AND
	rpv.vscode =
	(
		SELECT
			MAX(v.vscode)
		FROM
			rateplan_version v
		WHERE
			v.tmcode = ctra.tmcode
	) AND
	ctra.tmcode = rp.tmcode AND
	psnh.sncode = sn.sncode AND
	psph.spcode = sp.spcode AND
	rpv.currency = fc.fc_id AND
	ps.co_id = dn.co_id(+) AND
	ps.sncode = dn.sncode(+) AND
	ps.co_id = pv.co_id(+) AND
	ps.sncode = pv.sncode(+)
--	AND ctra.co_code = 'CONTR0000000033'
ORDER BY
	rp_code,
	sp_code,
	sn_code,
	sn_status,
	dn.dn_id,
	dn.dn_num
----------------------------------------------------------------
SELECT
    *
FROM
    ccontact_all
WHERE
    customer_id IN(
        SELECT
            customer_id
        FROM
            customer_all
        WHERE
            custcode = '1.3559'
    );
----------------------------------------------------------------
SELECT
    OHINVAMT_DOC
FROM
    orderhdr_all
WHERE
    customer_id IN(
        SELECT
            customer_id
        FROM
            customer_all
        WHERE
            custcode = '1.3559'
    )
    AND OHSTATUS = 'IN'
    AND 1 = 1;
----------------------------------------------------------------
SELECT DISTINCT
	ctra.co_code AS co_code,
	UPPER(cus.ch_status) AS co_status,
	cua.business_unit_id
FROM
	customer_all cua,
	ccontact_all ctoa,
	contract_all ctra,
	curr_co_status cus,
	profile_service ps,
	pr_serv_status_hist psnh,
	pr_serv_spcode_hist psph,
	mpulktmb tmb,
	rateplan rp,
	rateplan_version rpv,
	mpusptab sp,
	mpusntab sn,
	forcurr fc,
	(
		SELECT
			csp.co_id,
			csp.sncode,
			dn.dn_id,
			dn.dn_num
		FROM
			contr_services_cap csp,
			directory_number dn
		WHERE
			csp.dn_id = dn.dn_id AND
			csp.cs_deactiv_date IS NULL
	) dn,
	(
		SELECT
			pv.co_id,
			pv.sncode,
			mpk.prm_des,
			pv.prm_description
		FROM
			parameter_value pv,
			mkt_parameter mpk
		WHERE
			pv.sccode = mpk.sccode AND
			pv.parameter_id = mpk.parameter_id
	) pv
WHERE
--	BSCSTEST
--	cua.custnum = 'CUST0000000030' AND
--	cua.custnum = '302000013920' AND
	cua.custnum = 'CUST0000000161' AND
	ctoa.ccseq='-1' AND
	cua.customer_id = ctoa.customer_id AND
	ctoa.customer_id = ctra.customer_id AND
	ctra.co_id = cus.co_id AND
	ctra.co_id = ps.co_id AND
	ps.co_id = psnh.co_id AND
	ps.profile_id = psnh.profile_id AND
	ps.sncode = psnh.sncode AND
	ps.status_histno = psnh.histno AND
	ps.co_id = psph.co_id AND
	ps.profile_id = psph.profile_id AND
	ps.sncode = psph.sncode AND
	ps.spcode_histno = psph.histno AND
	ctra.tmcode = tmb.tmcode AND
	rpv.vscode = tmb.vscode AND
	psnh.sncode = tmb.sncode AND
	psph.spcode = tmb.spcode AND
	rpv.tmcode = rp.tmcode AND
	rpv.vscode =
	(
		SELECT
			MAX(v.vscode)
		FROM
			rateplan_version v
		WHERE
			v.tmcode = ctra.tmcode
	) AND
	ctra.tmcode = rp.tmcode AND
	psnh.sncode = sn.sncode AND
	psph.spcode = sp.spcode AND
	rpv.currency = fc.fc_id AND
	ps.co_id = dn.co_id(+) AND
	ps.sncode = dn.sncode(+) AND
	ps.co_id = pv.co_id(+) AND
	ps.sncode = pv.sncode(+)
ORDER BY
	co_code,
	co_status,
	cua.business_unit_id
----------------------------------------------------------------
SELECT DISTINCT
	cua.custnum,
	cua.customer_id,
	decode(ctoa.cctitle,1,'M',2,'F','M') gender,
	ctoa.ccfname,
	ctoa.cclname,
	ctoa.cctn,
	ctoa.ccemail
FROM
	customer_all cua,
	ccontact_all ctoa,
	contract_all ctra,
	curr_co_status cus,
	profile_service ps,
	pr_serv_status_hist psnh,
	pr_serv_spcode_hist psph,
	mpulktmb tmb,
	rateplan rp,
	rateplan_version rpv,
	mpusptab sp,
	mpusntab sn,
	forcurr fc,
	(
		SELECT
			csp.co_id,
			csp.sncode,
			dn.dn_id,
			dn.dn_num
		FROM
			contr_services_cap csp,
			directory_number dn
		WHERE
			csp.dn_id = dn.dn_id AND
			csp.cs_deactiv_date IS NULL
	) dn,
	(
		SELECT
			pv.co_id,
			pv.sncode,
			mpk.prm_des,
			pv.prm_description
		FROM
			parameter_value pv,
			mkt_parameter mpk
		WHERE
			pv.sccode = mpk.sccode AND
			pv.parameter_id = mpk.parameter_id
	) pv
WHERE
--	BSCSTEST
--	cua.custnum = 'CUST0000000030' AND
--	cua.custnum = '302000013920' AND
	cua.custnum = 'CUST0000000161' AND
	ctoa.ccseq='-1' AND
	cua.customer_id = ctoa.customer_id AND
	ctoa.customer_id = ctra.customer_id AND
	ctra.co_id = cus.co_id AND
	ctra.co_id = ps.co_id AND
	ps.co_id = psnh.co_id AND
	ps.profile_id = psnh.profile_id AND
	ps.sncode = psnh.sncode AND
	ps.status_histno = psnh.histno AND
	ps.co_id = psph.co_id AND
	ps.profile_id = psph.profile_id AND
	ps.sncode = psph.sncode AND
	ps.spcode_histno = psph.histno AND
	ctra.tmcode = tmb.tmcode AND
	rpv.vscode = tmb.vscode AND
	psnh.sncode = tmb.sncode AND
	psph.spcode = tmb.spcode AND
	rpv.tmcode = rp.tmcode AND
	rpv.vscode =
	(
		SELECT
			MAX(v.vscode)
		FROM
			rateplan_version v
		WHERE
			v.tmcode = ctra.tmcode
	) AND
	ctra.tmcode = rp.tmcode AND
	psnh.sncode = sn.sncode AND
	psph.spcode = sp.spcode AND
	rpv.currency = fc.fc_id AND
	ps.co_id = dn.co_id(+) AND
	ps.sncode = dn.sncode(+) AND
	ps.co_id = pv.co_id(+) AND
	ps.sncode = pv.sncode(+)
ORDER BY
	cua.custnum,
	cua.customer_id,
	gender,
	ctoa.ccfname,
	ctoa.cclname,
	ctoa.cctn,
	ctoa.ccemail
----------------------------------------------------------------
================================================================
							BSCSTEST
================================================================
--UPDATE
--	credit_barring
--SET
--	status = NULL,
--	description = NULL,
--	orderid = NULL
--WHERE
--	customer_id IN (3138,3327) AND
--	command IN ('R','S');
----------------------------------------------------------------
SELECT DISTINCT
	coa.customer_id, 
--	coa.co_id,
--	coa.co_code,
--	cua.custnum,
	cua.business_unit_id,
	cb.command,
 	cb.status,
	cb.description,
	cb.orderid,
	coa.co_code as co_code,
	rp.shdes as rp_code, 
	sp.shdes as sp_code, 
	sn.shdes as sn_code
FROM
	contract_all coa,
	credit_barring cb, 
	customer_all cua,
	profile_service ps,
	pr_serv_status_hist psnh,
	pr_serv_spcode_hist psph,
	mpulktmb tmb,
	rateplan rp,
	rateplan_version rpv,
	mpusptab sp,
	mpusntab sn,
	forcurr fc,
	(
		SELECT
			csp.co_id, 
			csp.sncode, 
			dn.dn_id, 
			dn.dn_num 
		FROM 
			contr_services_cap csp, 
			directory_number dn
		WHERE
			csp.dn_id = dn.dn_id AND 
			csp.cs_deactiv_date IS NULL 
	) dn,
	(
		SELECT 
			pv.co_id, 
			pv.sncode, 
			mpk.prm_des, 
			pv.prm_description 
		FROM 
			parameter_value pv, 
			mkt_parameter mpk 
		WHERE 
			pv.sccode = mpk.sccode AND 
			pv.parameter_id = mpk.parameter_id 
	) pv
WHERE 
	coa.customer_id = cb.customer_id  AND
	cb.customer_id = cua.customer_id AND
	cb.orderid = '5e227237-988f-41' AND
--	cua.customer_id IN (3138, 3327) AND
--	cua.customer_id IN (3327) AND
	coa.co_id = ps.co_id AND 
    ps.co_id = psnh.co_id AND 
    ps.profile_id = psnh.profile_id AND 
    ps.sncode = psnh.sncode AND 
    ps.status_histno = psnh.histno AND 
    ps.co_id = psph.co_id AND 
    ps.profile_id = psph.profile_id AND 
    ps.sncode = psph.sncode AND 
    ps.spcode_histno = psph.histno AND 
    coa.tmcode = tmb.tmcode AND 
    rpv.vscode = tmb.vscode AND 
    psnh.sncode = tmb.sncode AND 
    psph.spcode = tmb.spcode AND 
    rpv.tmcode = rp.tmcode AND 
    rpv.vscode = 
    (
    	SELECT
    		MAX(v.vscode) 
    	FROM 
    		rateplan_version v 
    	WHERE 
    		v.tmcode = coa.tmcode
    ) AND 
	coa.tmcode = rp.tmcode AND 
	psnh.sncode = sn.sncode AND 
	psph.spcode = sp.spcode AND 
	rpv.currency = fc.fc_id AND 
	ps.co_id = dn.co_id(+) AND 
	ps.sncode = dn.sncode(+) AND 
	ps.co_id = pv.co_id(+) AND 
	ps.sncode = pv.sncode(+) AND 
--	coa.co_code IN ('CONTR0000000388', 'CONTR0001012730', 'CONTR0001012739', 'CONTR0001012834') AND 
--	coa.co_code IN ('CONTR0001012847') AND 
	psnh.status = 'A'
ORDER BY
	coa.customer_id, 
--	coa.co_id,
--	co_code,
 	cua.business_unit_id,
	cb.command,
	cb.status,
	cb.description,
	cb.orderid,
	co_code, 
	rp_code, 
	sp_code, 
	sn_code;
----------------------------------------------------------------