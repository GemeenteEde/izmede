--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: fn_datumdmj(date); Type: FUNCTION; Schema: public; Owner: skinkie
--

CREATE FUNCTION fn_datumdmj(datum date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE sResult character varying(10); mm character varying(2); dd character varying(2);
BEGIN

if (date_part('year', datum)>0) then
	sResult = to_char(datum, 'DD-MM-YYYY');
end if;

   RETURN sResult;
END;
$$;


ALTER FUNCTION public.fn_datumdmj(datum date) OWNER TO skinkie;

--
-- Name: fn_datumjmd(date); Type: FUNCTION; Schema: public; Owner: skinkie
--

CREATE FUNCTION fn_datumjmd(datum date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE sResult character varying(10); mm character varying(2); dd character varying(2);
BEGIN

if (date_part('year', datum)>0) then
	sResult = to_char(datum, 'YYYYMMDD');
end if;

   RETURN sResult;
END;
$$;


ALTER FUNCTION public.fn_datumjmd(datum date) OWNER TO skinkie;

--
-- Name: fn_inleesstatus(character varying); Type: FUNCTION; Schema: public; Owner: skinkie
--

CREATE FUNCTION fn_inleesstatus(sbron character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE MyVar character varying(10);
BEGIN

SELECT status INTO MyVar FROM syst_inlees WHERE syst=sBron;

   RETURN MyVar;
END;
$$;


ALTER FUNCTION public.fn_inleesstatus(sbron character varying) OWNER TO skinkie;

--
-- Name: fn_xdagen(integer, integer); Type: FUNCTION; Schema: public; Owner: skinkie
--

CREATE FUNCTION fn_xdagen(xdagen integer, xuren integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
   RETURN xdagen + (xuren/8);
END;
$$;


ALTER FUNCTION public.fn_xdagen(xdagen integer, xuren integer) OWNER TO skinkie;

--
-- Name: jr_test1(integer); Type: FUNCTION; Schema: public; Owner: skinkie
--

CREATE FUNCTION jr_test1(i integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
   RETURN i + 1;
END;
$$;


ALTER FUNCTION public.jr_test1(i integer) OWNER TO skinkie;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bsb; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE bsb (
    bsn numeric(9,0),
    allegronummer numeric(9,0) NOT NULL,
    volgnummer smallint DEFAULT 0 NOT NULL,
    betreft character varying(2) NOT NULL,
    datumaanvraag date NOT NULL,
    datumvan date,
    datumeind date,
    status character varying(1),
    mdw character varying(12),
    last_update date DEFAULT ('now'::text)::date
);


ALTER TABLE public.bsb OWNER TO skinkie;

--
-- Name: bsb_br; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE bsb_br (
    bsn numeric(9,0),
    allegronummer numeric(9,0) NOT NULL,
    volgnummer smallint DEFAULT 0 NOT NULL,
    betreft character varying(2),
    datumaanvraag date,
    datumvan date,
    datumeind date,
    status character varying(1),
    mdw character varying(12)
);


ALTER TABLE public.bsb_br OWNER TO skinkie;

--
-- Name: bsb_feq; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE bsb_feq (
    bsn numeric(9,0) NOT NULL,
    jr_van smallint DEFAULT 0,
    jr_tm smallint DEFAULT 0,
    xtotaal smallint DEFAULT 0,
    xbr smallint DEFAULT 0,
    xsr smallint DEFAULT 0,
    xrest smallint DEFAULT 0,
    last_update date DEFAULT ('now'::text)::date
);


ALTER TABLE public.bsb_feq OWNER TO skinkie;

--
-- Name: bsb_mdw; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE bsb_mdw (
    mdw character varying(12) NOT NULL,
    medewerker character varying(50)
);


ALTER TABLE public.bsb_mdw OWNER TO skinkie;

--
-- Name: bsb_rest; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE bsb_rest (
    bsn numeric(9,0),
    allegronummer numeric(9,0) NOT NULL,
    volgnummer smallint DEFAULT 0 NOT NULL,
    betreft character varying(2),
    datumaanvraag date
);


ALTER TABLE public.bsb_rest OWNER TO skinkie;

--
-- Name: bsb_sr; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE bsb_sr (
    bsn numeric(9,0),
    allegronummer numeric(9,0) NOT NULL,
    volgnummer smallint DEFAULT 0 NOT NULL,
    betreft character varying(2),
    datumaanvraag date NOT NULL,
    datumvan date,
    datumeind date,
    status character varying(1),
    mdw character varying(12)
);


ALTER TABLE public.bsb_sr OWNER TO skinkie;

--
-- Name: bsn_feq; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE bsn_feq (
    bsn numeric(9,0) NOT NULL,
    jr_van smallint,
    jr_tm smallint,
    xgws smallint DEFAULT 0,
    xbsb smallint DEFAULT 0,
    xlpt smallint DEFAULT 0,
    xsyst smallint DEFAULT 0,
    last_update date DEFAULT ('now'::text)::date
);


ALTER TABLE public.bsn_feq OWNER TO skinkie;

--
-- Name: groepsdossier; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE groepsdossier (
    id integer NOT NULL,
    naam character varying(32)
);


ALTER TABLE public.groepsdossier OWNER TO skinkie;

--
-- Name: groepsdossier_bsn; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE groepsdossier_bsn (
    gid integer,
    bsn numeric(9,0),
    id integer NOT NULL
);


ALTER TABLE public.groepsdossier_bsn OWNER TO skinkie;

--
-- Name: groepsdossier_bsn_id_seq; Type: SEQUENCE; Schema: public; Owner: skinkie
--

CREATE SEQUENCE groepsdossier_bsn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groepsdossier_bsn_id_seq OWNER TO skinkie;

--
-- Name: groepsdossier_bsn_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skinkie
--

ALTER SEQUENCE groepsdossier_bsn_id_seq OWNED BY groepsdossier_bsn.id;


--
-- Name: groepsdossier_id_seq; Type: SEQUENCE; Schema: public; Owner: skinkie
--

CREATE SEQUENCE groepsdossier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groepsdossier_id_seq OWNER TO skinkie;

--
-- Name: groepsdossier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skinkie
--

ALTER SEQUENCE groepsdossier_id_seq OWNED BY groepsdossier.id;


--
-- Name: gws; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE gws (
    bsn numeric(9,0),
    srt character varying(1),
    bron character varying(3) NOT NULL,
    dossier numeric(9,0) NOT NULL,
    cdrg numeric(9,0),
    mdw character varying(3),
    datumvan date,
    datumeind date,
    datumlaatst date,
    leefvorm smallint DEFAULT 0,
    huisvesting smallint DEFAULT 0,
    burgstaat smallint DEFAULT 0,
    omschrijving character varying(30),
    last_update date DEFAULT ('now'::text)::date
);


ALTER TABLE public.gws OWNER TO skinkie;

--
-- Name: gws_feq; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE gws_feq (
    bsn numeric(9,0) NOT NULL,
    jr_van smallint DEFAULT 0,
    jr_tm smallint DEFAULT 0,
    xtotaal smallint DEFAULT 0,
    xinc smallint DEFAULT 0,
    xwmo smallint DEFAULT 0,
    xbb smallint DEFAULT 0,
    xlo smallint DEFAULT 0,
    xincidenteel smallint DEFAULT 0,
    xperiodiek smallint DEFAULT 0,
    last_update date DEFAULT ('now'::text)::date
);


ALTER TABLE public.gws_feq OWNER TO skinkie;

--
-- Name: gws_inc; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE gws_inc (
    bsn numeric(9,0),
    dossier numeric(9,0) NOT NULL,
    cdrg smallint DEFAULT 0,
    mdw character varying(3),
    datumlaatst date,
    leefvorm smallint DEFAULT 0,
    huisvesting smallint DEFAULT 0,
    omschrijving character varying(30)
);


ALTER TABLE public.gws_inc OWNER TO skinkie;

--
-- Name: gws_iwmo; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE gws_iwmo (
    bsn numeric(9,0),
    dossier numeric(9,0) NOT NULL,
    cdrg smallint DEFAULT 0,
    mdw character varying(3),
    datumlaatst date,
    huisvesting smallint DEFAULT 0,
    burgstaat smallint DEFAULT 0,
    omschrijving character varying(30)
);


ALTER TABLE public.gws_iwmo OWNER TO skinkie;

--
-- Name: gws_pbb; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE gws_pbb (
    bsn numeric(9,0),
    dossier numeric(9,0) NOT NULL,
    cdrg smallint DEFAULT 0,
    mdw character varying(3),
    datumvan date,
    datumeind date,
    datumlaatst date,
    leefvorm smallint DEFAULT 0,
    huisvesting smallint DEFAULT 0,
    omschrijving character varying(30)
);


ALTER TABLE public.gws_pbb OWNER TO skinkie;

--
-- Name: gws_plo; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE gws_plo (
    bsn numeric(9,0),
    dossier numeric(9,0) NOT NULL,
    cdrg smallint DEFAULT 0,
    mdw character varying(3),
    datumvan date,
    datumeind date,
    datumlaatst date,
    leefvorm smallint DEFAULT 0,
    huisvesting smallint DEFAULT 0,
    omschrijving character varying(30)
);


ALTER TABLE public.gws_plo OWNER TO skinkie;

--
-- Name: gws_rbs; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE gws_rbs (
    burgstaat smallint DEFAULT 0 NOT NULL,
    omschrijving character varying(35)
);


ALTER TABLE public.gws_rbs OWNER TO skinkie;

--
-- Name: gws_rhv; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE gws_rhv (
    huisvesting smallint DEFAULT 0 NOT NULL,
    omschrijving character varying(35)
);


ALTER TABLE public.gws_rhv OWNER TO skinkie;

--
-- Name: gws_ric; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE gws_ric (
    mdw character varying(3) NOT NULL,
    medewerker character varying(50)
);


ALTER TABLE public.gws_ric OWNER TO skinkie;

--
-- Name: gws_rlv; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE gws_rlv (
    leefvorm smallint DEFAULT 0 NOT NULL,
    omschrijving character varying(35)
);


ALTER TABLE public.gws_rlv OWNER TO skinkie;

--
-- Name: gws_rrg; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE gws_rrg (
    cdrg smallint DEFAULT 0 NOT NULL,
    regeling character varying(30)
);


ALTER TABLE public.gws_rrg OWNER TO skinkie;

--
-- Name: izm_prs_nat; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE izm_prs_nat (
    bsn numeric(9,0) NOT NULL,
    code integer NOT NULL,
    omschrijving text NOT NULL
);


ALTER TABLE public.izm_prs_nat OWNER TO skinkie;

--
-- Name: izm_prs_oud; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE izm_prs_oud (
    bsn numeric(9,0) NOT NULL,
    prssleutel bigint NOT NULL,
    prsoudsleutel bigint NOT NULL,
    subprssleutel bigint NOT NULL,
    subbsn numeric(9,0)
);


ALTER TABLE public.izm_prs_oud OWNER TO skinkie;

--
-- Name: izm_prs_prsadrcor; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE izm_prs_prsadrcor (
    bsn numeric(9,0) NOT NULL,
    prssleutel bigint NOT NULL,
    prsadrcorsleutel bigint NOT NULL,
    adrsleutel bigint NOT NULL
);


ALTER TABLE public.izm_prs_prsadrcor OWNER TO skinkie;

--
-- Name: izm_prs_prsadrins; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE izm_prs_prsadrins (
    bsn numeric(9,0) NOT NULL,
    prssleutel bigint NOT NULL,
    prsadrinssleutel bigint NOT NULL,
    adrsleutel bigint NOT NULL
);


ALTER TABLE public.izm_prs_prsadrins OWNER TO skinkie;

--
-- Name: izm_stamboom_huwelijk; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE izm_stamboom_huwelijk (
    stuf_sleutelgegevensbeheer bigint NOT NULL,
    bsn numeric(9,0) NOT NULL
);


ALTER TABLE public.izm_stamboom_huwelijk OWNER TO skinkie;

--
-- Name: izm_stamboom_ouder_kind; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE izm_stamboom_ouder_kind (
    stuf_sleutelgegevensbeheer bigint NOT NULL,
    ouder numeric(9,0) NOT NULL,
    kind numeric(9,0) NOT NULL
);


ALTER TABLE public.izm_stamboom_ouder_kind OWNER TO skinkie;

--
-- Name: lpt; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE lpt (
    lpt_id integer NOT NULL,
    bron character varying(3) NOT NULL,
    bsn numeric(9,0),
    datum date,
    betreft character varying(18),
    info character varying(35),
    brin character varying(4),
    last_update date DEFAULT ('now'::text)::date
);


ALTER TABLE public.lpt OWNER TO skinkie;

--
-- Name: lpt_beh; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE lpt_beh (
    bsn numeric(9,0) NOT NULL,
    beheerder character varying(25)
);


ALTER TABLE public.lpt_beh OWNER TO skinkie;

--
-- Name: lpt_feq; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE lpt_feq (
    bsn numeric(9,0) NOT NULL,
    beheerder character varying(25),
    jr_van numeric(4,0),
    jr_tm numeric(4,0),
    xtotaal integer,
    xverzuim integer,
    xschorsing integer,
    xpv integer,
    xluxe integer,
    last_update date DEFAULT ('now'::text)::date
);


ALTER TABLE public.lpt_feq OWNER TO skinkie;

--
-- Name: lpt_pv; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE lpt_pv (
    pvb_id integer NOT NULL,
    bsn numeric(9,0),
    pvb_datum date
);


ALTER TABLE public.lpt_pv OWNER TO skinkie;

--
-- Name: lpt_sch; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE lpt_sch (
    sch_id integer NOT NULL,
    bsn numeric(9,0),
    datumstart date,
    datumeind date,
    school character varying(60),
    brin character(4)
);


ALTER TABLE public.lpt_sch OWNER TO skinkie;

--
-- Name: lpt_vz; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE lpt_vz (
    vz_id integer NOT NULL,
    bsn numeric(9,0),
    verzuimdatum date,
    melddatum date,
    type character varying(35),
    reden character varying(35),
    duurdagen integer,
    duururen integer,
    school character varying(80),
    brin character(4)
);


ALTER TABLE public.lpt_vz OWNER TO skinkie;

--
-- Name: ref_bsb_cd; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE ref_bsb_cd (
    cd character varying(2) NOT NULL,
    cd_oms character varying(20) NOT NULL,
    actief character(1)
);


ALTER TABLE public.ref_bsb_cd OWNER TO skinkie;

--
-- Name: ref_gws_cdrg; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE ref_gws_cdrg (
    cdrg integer NOT NULL,
    regeling character varying(30),
    oms_kort character varying(10) DEFAULT 'ONB'::character varying
);


ALTER TABLE public.ref_gws_cdrg OWNER TO skinkie;

--
-- Name: ref_lpt_brin; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE ref_lpt_brin (
    brin character(4),
    soort character(3),
    school character varying(80),
    plaats character varying(24),
    website character varying(60),
    telefoon character varying(16)
);


ALTER TABLE public.ref_lpt_brin OWNER TO skinkie;

--
-- Name: ref_lpt_vz; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE ref_lpt_vz (
    type character varying(35) NOT NULL,
    verzuimtype character varying(20)
);


ALTER TABLE public.ref_lpt_vz OWNER TO skinkie;

--
-- Name: syst_inlees; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE syst_inlees (
    syst character varying(3) NOT NULL,
    starttijd timestamp without time zone,
    eindtijd timestamp without time zone,
    status character varying(10) DEFAULT '-'::character varying,
    counter integer DEFAULT 0
);


ALTER TABLE public.syst_inlees OWNER TO skinkie;

--
-- Name: syst_users; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE syst_users (
    syst_user character varying(7) NOT NULL,
    syst_username character varying(20) NOT NULL,
    syst_groep character varying(10) DEFAULT 'none'::character varying
);


ALTER TABLE public.syst_users OWNER TO skinkie;

--
-- Name: vr_bsn; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE vr_bsn (
    grp_id numeric(9,0) NOT NULL,
    bsn numeric(9,0) NOT NULL,
    jn_show smallint DEFAULT 1
);


ALTER TABLE public.vr_bsn OWNER TO skinkie;

--
-- Name: vr_grp; Type: TABLE; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE TABLE vr_grp (
    grp_id numeric(9,0) NOT NULL,
    grpnaam character varying(25) NOT NULL,
    actueel smallint DEFAULT 1,
    xbsn integer DEFAULT 0,
    jr_van numeric(4,0),
    jr_tm numeric(4,0),
    xnat integer DEFAULT 0,
    xhuw integer DEFAULT 0,
    xont integer DEFAULT 0,
    xknd integer DEFAULT 0,
    xtotaal integer DEFAULT 0,
    xlpt integer DEFAULT 0,
    xgws integer DEFAULT 0,
    xbsb integer DEFAULT 0,
    last_update date DEFAULT ('now'::text)::date
);


ALTER TABLE public.vr_grp OWNER TO skinkie;

--
-- Name: vw_gd_feqbron; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_gd_feqbron AS
    (SELECT gws_feq.bsn, 'GWS: Uitkering'::text AS systeem, gws_feq.jr_van, gws_feq.jr_tm, gws_feq.xtotaal AS totaal, 1 AS vlgnr FROM gws_feq UNION SELECT bsb_feq.bsn, 'BSB: Schuldhulp'::text AS systeem, bsb_feq.jr_van, bsb_feq.jr_tm, bsb_feq.xtotaal AS totaal, 2 AS vlgnr FROM bsb_feq) UNION SELECT lpt_feq.bsn, 'LPT: Leerplicht'::text AS systeem, lpt_feq.jr_van, lpt_feq.jr_tm, lpt_feq.xtotaal AS totaal, 3 AS vlgnr FROM lpt_feq;


ALTER TABLE public.vw_gd_feqbron OWNER TO skinkie;

--
-- Name: vw_gd_feqpers; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_gd_feqpers AS
    SELECT bsn_feq.bsn, bsn_feq.jr_van, bsn_feq.jr_tm, bsn_feq.xgws, bsn_feq.xbsb, bsn_feq.xlpt, bsn_feq.xsyst AS totaal FROM bsn_feq;


ALTER TABLE public.vw_gd_feqpers OWNER TO skinkie;

--
-- Name: vw_gd_inckort_bsb; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_gd_inckort_bsb AS
    SELECT bsb.bsn, 'Schulhulp'::text AS systeem, bsb.datumaanvraag AS datum, bsb.betreft, COALESCE(ref_bsb_cd.cd_oms, 'Code onbekend'::character varying) AS info, 2 AS vlgnr FROM (bsb LEFT JOIN ref_bsb_cd ON (((bsb.betreft)::text = (ref_bsb_cd.cd)::text)));


ALTER TABLE public.vw_gd_inckort_bsb OWNER TO skinkie;

--
-- Name: vw_gd_inckort_gws; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_gd_inckort_gws AS
    SELECT gws.bsn, 'Uitkering'::text AS systeem, gws.datumvan AS datum, COALESCE(ref_gws_cdrg.oms_kort, 'ONB'::character varying) AS betreft, gws.omschrijving AS info, 1 AS vlgnr FROM (gws LEFT JOIN ref_gws_cdrg ON ((gws.cdrg = (ref_gws_cdrg.cdrg)::numeric)));


ALTER TABLE public.vw_gd_inckort_gws OWNER TO skinkie;

--
-- Name: vw_gd_inckort_lpt; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_gd_inckort_lpt AS
    SELECT lpt.bsn, 'Leerplicht'::text AS systeem, lpt.datum, lpt.betreft, lpt.info, 3 AS vlgnr FROM lpt;


ALTER TABLE public.vw_gd_inckort_lpt OWNER TO skinkie;

--
-- Name: vw_gd_inckort; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_gd_inckort AS
    (SELECT vw_gd_inckort_gws.bsn, vw_gd_inckort_gws.systeem, vw_gd_inckort_gws.datum, vw_gd_inckort_gws.betreft, vw_gd_inckort_gws.info, vw_gd_inckort_gws.vlgnr FROM vw_gd_inckort_gws UNION SELECT vw_gd_inckort_bsb.bsn, vw_gd_inckort_bsb.systeem, vw_gd_inckort_bsb.datum, vw_gd_inckort_bsb.betreft, vw_gd_inckort_bsb.info, vw_gd_inckort_bsb.vlgnr FROM vw_gd_inckort_bsb) UNION SELECT vw_gd_inckort_lpt.bsn, vw_gd_inckort_lpt.systeem, vw_gd_inckort_lpt.datum, vw_gd_inckort_lpt.betreft, vw_gd_inckort_lpt.info, vw_gd_inckort_lpt.vlgnr FROM vw_gd_inckort_lpt;


ALTER TABLE public.vw_gd_inckort OWNER TO skinkie;

--
-- Name: vw_izm_bsn01; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_izm_bsn01 AS
    SELECT bsn_feq.bsn, bsn_feq.jr_van, bsn_feq.jr_tm, bsn_feq.xgws, bsn_feq.xbsb, bsn_feq.xlpt, bsn_feq.xsyst, bsn_feq.last_update FROM bsn_feq;


ALTER TABLE public.vw_izm_bsn01 OWNER TO skinkie;

--
-- Name: vw_izm_bsn02; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_izm_bsn02 AS
    SELECT bsn_feq.bsn, bsn_feq.jr_tm, CASE WHEN (bsn_feq.xgws > 0) THEN 'J'::text ELSE 'N'::text END AS jn_gws, CASE WHEN (bsn_feq.xbsb > 0) THEN 'J'::text ELSE 'N'::text END AS jn_bsb, CASE WHEN (bsn_feq.xlpt > 0) THEN 'J'::text ELSE 'N'::text END AS jn_lpt, bsn_feq.xsyst FROM bsn_feq;


ALTER TABLE public.vw_izm_bsn02 OWNER TO skinkie;

--
-- Name: vw_izm_syst1; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_izm_syst1 AS
    ((SELECT 'BSB'::text AS bron, max(bsb_feq.last_update) AS lastrecordupdate FROM bsb_feq UNION SELECT 'GWS'::text AS bron, max(gws_feq.last_update) AS lastrecordupdate FROM gws_feq) UNION SELECT 'LPT'::text AS bron, max(lpt_feq.last_update) AS lastrecordupdate FROM lpt_feq) UNION SELECT 'BSN'::text AS bron, max(bsn_feq.last_update) AS lastrecordupdate FROM bsn_feq;


ALTER TABLE public.vw_izm_syst1 OWNER TO skinkie;

--
-- Name: vw_izm_syst2; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_izm_syst2 AS
    SELECT syst_inlees.syst, syst_inlees.starttijd, syst_inlees.status, syst_inlees.counter, vw_izm_syst1.lastrecordupdate FROM (syst_inlees JOIN vw_izm_syst1 ON (((syst_inlees.syst)::text = vw_izm_syst1.bron))) ORDER BY syst_inlees.starttijd;


ALTER TABLE public.vw_izm_syst2 OWNER TO skinkie;

--
-- Name: vw_pd_bsb_br; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_bsb_br AS
    SELECT bsb_br.bsn, fn_datumjmd(bsb_br.datumaanvraag) AS datum, ref_bsb_cd.cd_oms AS betreft, pg_catalog.concat(bsb_br.allegronummer, '-', bsb_br.volgnummer) AS dossier, fn_datumjmd(bsb_br.datumaanvraag) AS aanvraag, fn_datumjmd(bsb_br.datumvan) AS startdatum, fn_datumjmd(bsb_br.datumeind) AS einddatum, bsb_mdw.medewerker FROM ((bsb_br LEFT JOIN bsb_mdw ON (((bsb_br.mdw)::text = (bsb_mdw.mdw)::text))) LEFT JOIN ref_bsb_cd ON (((bsb_br.betreft)::text = (ref_bsb_cd.cd)::text)));


ALTER TABLE public.vw_pd_bsb_br OWNER TO skinkie;

--
-- Name: vw_pd_bsb_rest; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_bsb_rest AS
    SELECT bsb_rest.bsn, fn_datumjmd(bsb_rest.datumaanvraag) AS datum, ref_bsb_cd.cd_oms AS betreft, pg_catalog.concat(bsb_rest.allegronummer, '-', bsb_rest.volgnummer) AS dossier, fn_datumjmd(bsb_rest.datumaanvraag) AS aanvraag, NULL::text AS startdatum, NULL::text AS einddatum, NULL::text AS medewerker FROM (bsb_rest LEFT JOIN ref_bsb_cd ON (((bsb_rest.betreft)::text = (ref_bsb_cd.cd)::text)));


ALTER TABLE public.vw_pd_bsb_rest OWNER TO skinkie;

--
-- Name: vw_pd_bsb_sr; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_bsb_sr AS
    SELECT bsb_sr.bsn, fn_datumjmd(bsb_sr.datumaanvraag) AS datum, ref_bsb_cd.cd_oms AS betreft, pg_catalog.concat(bsb_sr.allegronummer, '-', bsb_sr.volgnummer) AS dossier, fn_datumjmd(bsb_sr.datumaanvraag) AS aanvraag, fn_datumjmd(bsb_sr.datumvan) AS startdatum, fn_datumjmd(bsb_sr.datumeind) AS einddatum, bsb_mdw.medewerker FROM ((bsb_sr LEFT JOIN bsb_mdw ON (((bsb_sr.mdw)::text = (bsb_mdw.mdw)::text))) LEFT JOIN ref_bsb_cd ON (((bsb_sr.betreft)::text = (ref_bsb_cd.cd)::text)));


ALTER TABLE public.vw_pd_bsb_sr OWNER TO skinkie;

--
-- Name: vw_pd_bsb; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_bsb AS
    (SELECT vw_pd_bsb_br.bsn, vw_pd_bsb_br.datum, vw_pd_bsb_br.betreft, vw_pd_bsb_br.dossier, vw_pd_bsb_br.aanvraag, vw_pd_bsb_br.startdatum, vw_pd_bsb_br.einddatum, vw_pd_bsb_br.medewerker FROM vw_pd_bsb_br UNION SELECT vw_pd_bsb_sr.bsn, vw_pd_bsb_sr.datum, vw_pd_bsb_sr.betreft, vw_pd_bsb_sr.dossier, vw_pd_bsb_sr.aanvraag, vw_pd_bsb_sr.startdatum, vw_pd_bsb_sr.einddatum, vw_pd_bsb_sr.medewerker FROM vw_pd_bsb_sr) UNION SELECT vw_pd_bsb_rest.bsn, vw_pd_bsb_rest.datum, vw_pd_bsb_rest.betreft, vw_pd_bsb_rest.dossier, vw_pd_bsb_rest.aanvraag, vw_pd_bsb_rest.startdatum, vw_pd_bsb_rest.einddatum, vw_pd_bsb_rest.medewerker FROM vw_pd_bsb_rest;


ALTER TABLE public.vw_pd_bsb OWNER TO skinkie;

--
-- Name: vw_pd_gws_inc; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_gws_inc AS
    SELECT gws_inc.bsn, fn_datumjmd(gws_inc.datumlaatst) AS datum, 'Incidenteel (Inc)'::text AS betreft, gws_inc.dossier, NULL::text AS startdatum, NULL::text AS einddatum, fn_datumjmd(gws_inc.datumlaatst) AS datumlaatst, COALESCE(ref_gws_cdrg.oms_kort, ((gws_inc.cdrg)::text)::character varying) AS regeling, gws_inc.omschrijving, gws_rlv.omschrijving AS leefvorm, gws_rhv.omschrijving AS huisvesting, NULL::text AS burgstaat, gws_ric.medewerker FROM (((gws_rhv RIGHT JOIN (gws_ric RIGHT JOIN gws_inc ON (((gws_ric.mdw)::text = (gws_inc.mdw)::text))) ON ((gws_rhv.huisvesting = gws_inc.huisvesting))) LEFT JOIN ref_gws_cdrg ON ((gws_inc.cdrg = ref_gws_cdrg.cdrg))) LEFT JOIN gws_rlv ON ((gws_inc.leefvorm = gws_rlv.leefvorm)));


ALTER TABLE public.vw_pd_gws_inc OWNER TO skinkie;

--
-- Name: vw_pd_gws_iwmo; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_gws_iwmo AS
    SELECT gws_iwmo.bsn, fn_datumjmd(gws_iwmo.datumlaatst) AS datum, 'Incidenteel (WMO)'::text AS betreft, gws_iwmo.dossier, NULL::text AS startdatum, NULL::text AS einddatum, fn_datumjmd(gws_iwmo.datumlaatst) AS datumlaatst, COALESCE(ref_gws_cdrg.oms_kort, ((gws_iwmo.cdrg)::text)::character varying) AS regeling, gws_iwmo.omschrijving, NULL::text AS leefvorm, gws_rhv.omschrijving AS huisvesting, gws_rbs.omschrijving AS burgstaat, gws_ric.medewerker FROM ((((gws_iwmo LEFT JOIN gws_ric ON (((gws_iwmo.mdw)::text = (gws_ric.mdw)::text))) LEFT JOIN gws_rhv ON ((gws_iwmo.huisvesting = gws_rhv.huisvesting))) LEFT JOIN ref_gws_cdrg ON ((gws_iwmo.cdrg = ref_gws_cdrg.cdrg))) LEFT JOIN gws_rbs ON ((gws_iwmo.burgstaat = gws_rbs.burgstaat)));


ALTER TABLE public.vw_pd_gws_iwmo OWNER TO skinkie;

--
-- Name: vw_pd_gws_pbb; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_gws_pbb AS
    SELECT gws_pbb.bsn, fn_datumjmd(gws_pbb.datumvan) AS datum, 'Periodiek (BB)'::text AS betreft, gws_pbb.dossier, fn_datumjmd(gws_pbb.datumvan) AS startdatum, fn_datumjmd(gws_pbb.datumeind) AS einddatum, fn_datumjmd(gws_pbb.datumlaatst) AS datumlaatst, COALESCE(ref_gws_cdrg.oms_kort, ((gws_pbb.cdrg)::text)::character varying) AS regeling, gws_pbb.omschrijving, gws_rlv.omschrijving AS leefvorm, gws_rhv.omschrijving AS huisvesting, NULL::text AS burgstaat, gws_ric.medewerker FROM ((((gws_pbb LEFT JOIN gws_rhv ON ((gws_pbb.huisvesting = gws_rhv.huisvesting))) LEFT JOIN gws_ric ON (((gws_pbb.mdw)::text = (gws_ric.mdw)::text))) LEFT JOIN gws_rlv ON ((gws_pbb.leefvorm = gws_rlv.leefvorm))) LEFT JOIN ref_gws_cdrg ON ((gws_pbb.cdrg = ref_gws_cdrg.cdrg)));


ALTER TABLE public.vw_pd_gws_pbb OWNER TO skinkie;

--
-- Name: vw_pd_gws_plo; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_gws_plo AS
    SELECT gws_plo.bsn, fn_datumjmd(gws_plo.datumvan) AS datum, 'Periodiek (LO)'::text AS betreft, gws_plo.dossier, fn_datumjmd(gws_plo.datumvan) AS startdatum, fn_datumjmd(gws_plo.datumeind) AS einddatum, fn_datumjmd(gws_plo.datumlaatst) AS datumlaatst, COALESCE(ref_gws_cdrg.oms_kort, ((gws_plo.cdrg)::text)::character varying) AS regeling, gws_plo.omschrijving, gws_rlv.omschrijving AS leefvorm, gws_rhv.omschrijving AS huisvesting, NULL::text AS burgstaat, gws_ric.medewerker FROM ((((gws_plo LEFT JOIN gws_rhv ON ((gws_plo.huisvesting = gws_rhv.huisvesting))) LEFT JOIN gws_ric ON (((gws_plo.mdw)::text = (gws_ric.mdw)::text))) LEFT JOIN gws_rlv ON ((gws_plo.leefvorm = gws_rlv.leefvorm))) LEFT JOIN ref_gws_cdrg ON ((gws_plo.cdrg = ref_gws_cdrg.cdrg)));


ALTER TABLE public.vw_pd_gws_plo OWNER TO skinkie;

--
-- Name: vw_pd_gws; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_gws AS
    ((SELECT vw_pd_gws_inc.bsn, vw_pd_gws_inc.datum, vw_pd_gws_inc.betreft, vw_pd_gws_inc.dossier, vw_pd_gws_inc.startdatum, vw_pd_gws_inc.einddatum, vw_pd_gws_inc.datumlaatst, vw_pd_gws_inc.regeling, vw_pd_gws_inc.omschrijving, vw_pd_gws_inc.leefvorm, vw_pd_gws_inc.huisvesting, vw_pd_gws_inc.burgstaat, vw_pd_gws_inc.medewerker FROM vw_pd_gws_inc UNION SELECT vw_pd_gws_iwmo.bsn, vw_pd_gws_iwmo.datum, vw_pd_gws_iwmo.betreft, vw_pd_gws_iwmo.dossier, vw_pd_gws_iwmo.startdatum, vw_pd_gws_iwmo.einddatum, vw_pd_gws_iwmo.datumlaatst, vw_pd_gws_iwmo.regeling, vw_pd_gws_iwmo.omschrijving, vw_pd_gws_iwmo.leefvorm, vw_pd_gws_iwmo.huisvesting, vw_pd_gws_iwmo.burgstaat, vw_pd_gws_iwmo.medewerker FROM vw_pd_gws_iwmo) UNION SELECT vw_pd_gws_pbb.bsn, vw_pd_gws_pbb.datum, vw_pd_gws_pbb.betreft, vw_pd_gws_pbb.dossier, vw_pd_gws_pbb.startdatum, vw_pd_gws_pbb.einddatum, vw_pd_gws_pbb.datumlaatst, vw_pd_gws_pbb.regeling, vw_pd_gws_pbb.omschrijving, vw_pd_gws_pbb.leefvorm, vw_pd_gws_pbb.huisvesting, vw_pd_gws_pbb.burgstaat, vw_pd_gws_pbb.medewerker FROM vw_pd_gws_pbb) UNION SELECT vw_pd_gws_plo.bsn, vw_pd_gws_plo.datum, vw_pd_gws_plo.betreft, vw_pd_gws_plo.dossier, vw_pd_gws_plo.startdatum, vw_pd_gws_plo.einddatum, vw_pd_gws_plo.datumlaatst, vw_pd_gws_plo.regeling, vw_pd_gws_plo.omschrijving, vw_pd_gws_plo.leefvorm, vw_pd_gws_plo.huisvesting, vw_pd_gws_plo.burgstaat, vw_pd_gws_plo.medewerker FROM vw_pd_gws_plo;


ALTER TABLE public.vw_pd_gws OWNER TO skinkie;

--
-- Name: vw_pd_lpt_pv; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_lpt_pv AS
    SELECT lpt_pv.bsn, to_char((lpt_pv.pvb_datum)::timestamp with time zone, 'YYYYMMDD'::text) AS datum, 'Proces-verbaal'::text AS betreft, lpt_pv.pvb_id AS dossier, to_char((lpt_pv.pvb_datum)::timestamp with time zone, 'YYYYMMDD'::text) AS startdatum, NULL::text AS einddatum, NULL::integer AS dagen, NULL::text AS type, NULL::text AS reden, NULL::text AS school FROM lpt_pv;


ALTER TABLE public.vw_pd_lpt_pv OWNER TO skinkie;

--
-- Name: vw_pd_lpt_sch; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_lpt_sch AS
    SELECT lpt_sch.bsn, to_char((lpt_sch.datumstart)::timestamp with time zone, 'YYYYMMDD'::text) AS datum, 'Schorsing'::text AS betreft, lpt_sch.sch_id AS dossier, to_char((lpt_sch.datumstart)::timestamp with time zone, 'YYYYMMDD'::text) AS startdatum, to_char((lpt_sch.datumeind)::timestamp with time zone, 'YYYYMMDD'::text) AS einddatum, NULL::integer AS dagen, NULL::text AS type, NULL::text AS reden, btrim(pg_catalog.concat(upper((lpt_sch.brin)::text), ' ', lpt_sch.school)) AS school FROM lpt_sch;


ALTER TABLE public.vw_pd_lpt_sch OWNER TO skinkie;

--
-- Name: vw_pd_lpt_vz; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_lpt_vz AS
    SELECT lpt_vz.bsn, to_char((lpt_vz.verzuimdatum)::timestamp with time zone, 'YYYYMMDD'::text) AS datum, 'Verzuim'::text AS betreft, lpt_vz.vz_id AS dossier, to_char((lpt_vz.verzuimdatum)::timestamp with time zone, 'YYYYMMDD'::text) AS startdatum, NULL::text AS einddatum, fn_xdagen(COALESCE(lpt_vz.duurdagen, 0), COALESCE(lpt_vz.duururen, 0)) AS dagen, COALESCE(ref_lpt_vz.verzuimtype, lpt_vz.type) AS type, lpt_vz.reden, btrim(pg_catalog.concat(upper((lpt_vz.brin)::text), ' ', lpt_vz.school)) AS school FROM (lpt_vz LEFT JOIN ref_lpt_vz ON (((lpt_vz.type)::text = (ref_lpt_vz.type)::text)));


ALTER TABLE public.vw_pd_lpt_vz OWNER TO skinkie;

--
-- Name: vw_pd_lpt; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vw_pd_lpt AS
    (SELECT vw_pd_lpt_vz.bsn, vw_pd_lpt_vz.datum, vw_pd_lpt_vz.betreft, vw_pd_lpt_vz.dossier, vw_pd_lpt_vz.startdatum, vw_pd_lpt_vz.einddatum, vw_pd_lpt_vz.dagen, vw_pd_lpt_vz.type, vw_pd_lpt_vz.reden, vw_pd_lpt_vz.school FROM vw_pd_lpt_vz UNION SELECT vw_pd_lpt_sch.bsn, vw_pd_lpt_sch.datum, vw_pd_lpt_sch.betreft, vw_pd_lpt_sch.dossier, vw_pd_lpt_sch.startdatum, vw_pd_lpt_sch.einddatum, vw_pd_lpt_sch.dagen, vw_pd_lpt_sch.type, vw_pd_lpt_sch.reden, vw_pd_lpt_sch.school FROM vw_pd_lpt_sch) UNION SELECT vw_pd_lpt_pv.bsn, vw_pd_lpt_pv.datum, vw_pd_lpt_pv.betreft, vw_pd_lpt_pv.dossier, vw_pd_lpt_pv.startdatum, vw_pd_lpt_pv.einddatum, vw_pd_lpt_pv.dagen, vw_pd_lpt_pv.type, vw_pd_lpt_pv.reden, vw_pd_lpt_pv.school FROM vw_pd_lpt_pv;


ALTER TABLE public.vw_pd_lpt OWNER TO skinkie;

--
-- Name: vwp_bsb_feq; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vwp_bsb_feq AS
    SELECT bsb.bsn, min(COALESCE(date_part('year'::text, bsb.datumaanvraag), (0)::double precision)) AS jr_van, max(COALESCE(date_part('year'::text, bsb.datumaanvraag), (0)::double precision)) AS jr_tm, count(bsb.bsn) AS xtotaal, sum(CASE WHEN ((bsb.betreft)::text = 'BR'::text) THEN 1 ELSE 0 END) AS xbr, sum(CASE WHEN ((bsb.betreft)::text = 'SR'::text) THEN 1 ELSE 0 END) AS xsr, sum(CASE WHEN (((bsb.betreft)::text = 'BR'::text) OR ((bsb.betreft)::text = 'SR'::text)) THEN 0 ELSE 1 END) AS xrest, COALESCE(max(bsb.last_update), ('now'::text)::date) AS last_update FROM bsb WHERE ((bsb.bsn > (0)::numeric) AND (bsb.datumaanvraag IS NOT NULL)) GROUP BY bsb.bsn;


ALTER TABLE public.vwp_bsb_feq OWNER TO skinkie;

--
-- Name: vwp_bsb_feq_delete; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vwp_bsb_feq_delete AS
    SELECT bsb_feq.bsn, bsb_feq.jr_van, bsb_feq.jr_tm, bsb_feq.xtotaal, bsb_feq.xbr, bsb_feq.xsr, bsb_feq.xrest FROM bsb_feq EXCEPT SELECT vwp_bsb_feq.bsn, vwp_bsb_feq.jr_van, vwp_bsb_feq.jr_tm, vwp_bsb_feq.xtotaal, vwp_bsb_feq.xbr, vwp_bsb_feq.xsr, vwp_bsb_feq.xrest FROM vwp_bsb_feq;


ALTER TABLE public.vwp_bsb_feq_delete OWNER TO skinkie;

--
-- Name: vwp_gws_feq; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vwp_gws_feq AS
    SELECT gws.bsn, min(date_part('year'::text, gws.datumvan)) AS jr_van, max(date_part('year'::text, gws.datumvan)) AS jr_tm, count(gws.bsn) AS xtotaal, sum(CASE WHEN ((gws.bron)::text = 'INC'::text) THEN 1 ELSE 0 END) AS xinc, sum(CASE WHEN ((gws.bron)::text = 'WMO'::text) THEN 1 ELSE 0 END) AS xwmo, sum(CASE WHEN ((gws.bron)::text = 'BB'::text) THEN 1 ELSE 0 END) AS xbb, sum(CASE WHEN ((gws.bron)::text = 'LO'::text) THEN 1 ELSE 0 END) AS xlo, sum(CASE WHEN ((gws.srt)::text = 'I'::text) THEN 1 ELSE 0 END) AS xincidenteel, sum(CASE WHEN ((gws.srt)::text = 'P'::text) THEN 1 ELSE 0 END) AS xperiodiek, max(gws.last_update) AS last_update FROM gws WHERE ((gws.bsn > (0)::numeric) AND (gws.datumvan IS NOT NULL)) GROUP BY gws.bsn;


ALTER TABLE public.vwp_gws_feq OWNER TO skinkie;

--
-- Name: vwp_gws_feq_delete; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vwp_gws_feq_delete AS
    SELECT gws_feq.bsn, gws_feq.jr_van, gws_feq.jr_tm, gws_feq.xtotaal, gws_feq.xinc, gws_feq.xwmo, gws_feq.xbb, gws_feq.xlo, gws_feq.xincidenteel, gws_feq.xperiodiek FROM gws_feq EXCEPT SELECT vwp_gws_feq.bsn, vwp_gws_feq.jr_van, vwp_gws_feq.jr_tm, vwp_gws_feq.xtotaal, vwp_gws_feq.xinc, vwp_gws_feq.xwmo, vwp_gws_feq.xbb, vwp_gws_feq.xlo, vwp_gws_feq.xincidenteel, vwp_gws_feq.xperiodiek FROM vwp_gws_feq;


ALTER TABLE public.vwp_gws_feq_delete OWNER TO skinkie;

--
-- Name: vwp_lpt_feq; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vwp_lpt_feq AS
    SELECT lpt.bsn, lpt_beh.beheerder, min(COALESCE(date_part('year'::text, lpt.datum), (0)::double precision)) AS jr_van, max(COALESCE(date_part('year'::text, lpt.datum), (0)::double precision)) AS jr_tm, count(lpt.bsn) AS xtotaal, sum(CASE WHEN ((lpt.bron)::text = 'VZ'::text) THEN 1 ELSE 0 END) AS xverzuim, sum(CASE WHEN ((lpt.bron)::text = 'SCH'::text) THEN 1 ELSE 0 END) AS xschorsing, sum(CASE WHEN ((lpt.bron)::text = 'PV'::text) THEN 1 ELSE 0 END) AS xpv, sum(CASE WHEN ((lpt.betreft)::text = 'Luxe verzuim'::text) THEN 1 ELSE 0 END) AS xluxe, COALESCE(max(lpt.last_update), ('now'::text)::date) AS last_update FROM (lpt LEFT JOIN lpt_beh ON ((lpt.bsn = lpt_beh.bsn))) WHERE ((lpt.bsn > (0)::numeric) AND (lpt.datum IS NOT NULL)) GROUP BY lpt.bsn, lpt_beh.beheerder;


ALTER TABLE public.vwp_lpt_feq OWNER TO skinkie;

--
-- Name: vwp_lpt_feq_delete; Type: VIEW; Schema: public; Owner: skinkie
--

CREATE VIEW vwp_lpt_feq_delete AS
    SELECT lpt_feq.bsn, lpt_feq.beheerder, lpt_feq.jr_van, lpt_feq.jr_tm, lpt_feq.xtotaal, lpt_feq.xverzuim, lpt_feq.xschorsing, lpt_feq.xpv, lpt_feq.xluxe FROM lpt_feq EXCEPT SELECT vwp_lpt_feq.bsn, vwp_lpt_feq.beheerder, vwp_lpt_feq.jr_van, vwp_lpt_feq.jr_tm, vwp_lpt_feq.xtotaal, vwp_lpt_feq.xverzuim, vwp_lpt_feq.xschorsing, vwp_lpt_feq.xpv, vwp_lpt_feq.xluxe FROM vwp_lpt_feq;


ALTER TABLE public.vwp_lpt_feq_delete OWNER TO skinkie;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: skinkie
--

ALTER TABLE ONLY groepsdossier ALTER COLUMN id SET DEFAULT nextval('groepsdossier_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: skinkie
--

ALTER TABLE ONLY groepsdossier_bsn ALTER COLUMN id SET DEFAULT nextval('groepsdossier_bsn_id_seq'::regclass);


--
-- Name: bsb_br_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY bsb_br
    ADD CONSTRAINT bsb_br_pkey PRIMARY KEY (allegronummer, volgnummer);


--
-- Name: bsb_feq_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY bsb_feq
    ADD CONSTRAINT bsb_feq_pkey PRIMARY KEY (bsn);


--
-- Name: bsb_mdw_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY bsb_mdw
    ADD CONSTRAINT bsb_mdw_pkey PRIMARY KEY (mdw);


--
-- Name: bsb_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY bsb
    ADD CONSTRAINT bsb_pkey PRIMARY KEY (allegronummer, volgnummer, betreft, datumaanvraag);


--
-- Name: bsb_rest_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY bsb_rest
    ADD CONSTRAINT bsb_rest_pkey PRIMARY KEY (allegronummer, volgnummer);


--
-- Name: bsb_sr_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY bsb_sr
    ADD CONSTRAINT bsb_sr_pkey PRIMARY KEY (allegronummer, volgnummer, datumaanvraag);


--
-- Name: bsn_feq_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY bsn_feq
    ADD CONSTRAINT bsn_feq_pkey PRIMARY KEY (bsn);


--
-- Name: groepsdossier_bsn_gid_bsn_key; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY groepsdossier_bsn
    ADD CONSTRAINT groepsdossier_bsn_gid_bsn_key UNIQUE (gid, bsn);


--
-- Name: groepsdossier_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY groepsdossier
    ADD CONSTRAINT groepsdossier_pkey PRIMARY KEY (id);


--
-- Name: gws_feq_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY gws_feq
    ADD CONSTRAINT gws_feq_pkey PRIMARY KEY (bsn);


--
-- Name: gws_inc_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY gws_inc
    ADD CONSTRAINT gws_inc_pkey PRIMARY KEY (dossier);


--
-- Name: gws_iwmo_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY gws_iwmo
    ADD CONSTRAINT gws_iwmo_pkey PRIMARY KEY (dossier);


--
-- Name: gws_pbb_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY gws_pbb
    ADD CONSTRAINT gws_pbb_pkey PRIMARY KEY (dossier);


--
-- Name: gws_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY gws
    ADD CONSTRAINT gws_pkey PRIMARY KEY (bron, dossier);


--
-- Name: gws_plo_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY gws_plo
    ADD CONSTRAINT gws_plo_pkey PRIMARY KEY (dossier);


--
-- Name: gws_rbs_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY gws_rbs
    ADD CONSTRAINT gws_rbs_pkey PRIMARY KEY (burgstaat);


--
-- Name: gws_rhv_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY gws_rhv
    ADD CONSTRAINT gws_rhv_pkey PRIMARY KEY (huisvesting);


--
-- Name: gws_ric_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY gws_ric
    ADD CONSTRAINT gws_ric_pkey PRIMARY KEY (mdw);


--
-- Name: gws_rlv_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY gws_rlv
    ADD CONSTRAINT gws_rlv_pkey PRIMARY KEY (leefvorm);


--
-- Name: gws_rrg_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY gws_rrg
    ADD CONSTRAINT gws_rrg_pkey PRIMARY KEY (cdrg);


--
-- Name: lpt_beh_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY lpt_beh
    ADD CONSTRAINT lpt_beh_pkey PRIMARY KEY (bsn);


--
-- Name: lpt_feq_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY lpt_feq
    ADD CONSTRAINT lpt_feq_pkey PRIMARY KEY (bsn);


--
-- Name: lpt_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY lpt
    ADD CONSTRAINT lpt_pkey PRIMARY KEY (lpt_id, bron);


--
-- Name: lpt_pv_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY lpt_pv
    ADD CONSTRAINT lpt_pv_pkey PRIMARY KEY (pvb_id);


--
-- Name: lpt_sch_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY lpt_sch
    ADD CONSTRAINT lpt_sch_pkey PRIMARY KEY (sch_id);


--
-- Name: lpt_vz_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY lpt_vz
    ADD CONSTRAINT lpt_vz_pkey PRIMARY KEY (vz_id);


--
-- Name: ref_bsb_cd_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY ref_bsb_cd
    ADD CONSTRAINT ref_bsb_cd_pkey PRIMARY KEY (cd);


--
-- Name: ref_gws_cdrg_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY ref_gws_cdrg
    ADD CONSTRAINT ref_gws_cdrg_pkey PRIMARY KEY (cdrg);


--
-- Name: ref_lpt_vz_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY ref_lpt_vz
    ADD CONSTRAINT ref_lpt_vz_pkey PRIMARY KEY (type);


--
-- Name: syst_inlees_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY syst_inlees
    ADD CONSTRAINT syst_inlees_pkey PRIMARY KEY (syst);


--
-- Name: syst_users_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY syst_users
    ADD CONSTRAINT syst_users_pkey PRIMARY KEY (syst_user);


--
-- Name: vr_bsn_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY vr_bsn
    ADD CONSTRAINT vr_bsn_pkey PRIMARY KEY (grp_id, bsn);


--
-- Name: vr_grp_pkey; Type: CONSTRAINT; Schema: public; Owner: skinkie; Tablespace: 
--

ALTER TABLE ONLY vr_grp
    ADD CONSTRAINT vr_grp_pkey PRIMARY KEY (grp_id);


--
-- Name: bsb_br_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX bsb_br_bsn ON bsb_br USING btree (bsn);


--
-- Name: bsb_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX bsb_bsn ON bsb USING btree (bsn);


--
-- Name: bsb_rest_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX bsb_rest_bsn ON bsb_rest USING btree (bsn);


--
-- Name: bsb_sr_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX bsb_sr_bsn ON bsb_sr USING btree (bsn);


--
-- Name: datumvan; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX datumvan ON gws USING btree (datumvan);


--
-- Name: groepsdossier_bsn_id; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX groepsdossier_bsn_id ON groepsdossier_bsn USING btree (id);


--
-- Name: gws_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX gws_bsn ON gws USING btree (bsn);


--
-- Name: gws_inc_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX gws_inc_bsn ON gws_inc USING btree (bsn);


--
-- Name: gws_iwmo_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX gws_iwmo_bsn ON gws_iwmo USING btree (bsn);


--
-- Name: gws_pbb_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX gws_pbb_bsn ON gws_pbb USING btree (bsn);


--
-- Name: gws_plo_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX gws_plo_bsn ON gws_plo USING btree (bsn);


--
-- Name: lpt_bron; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX lpt_bron ON lpt USING btree (bron);


--
-- Name: lpt_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX lpt_bsn ON lpt USING btree (bsn);


--
-- Name: lpt_pv_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX lpt_pv_bsn ON lpt_pv USING btree (bsn);


--
-- Name: lpt_sch_brin; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX lpt_sch_brin ON lpt_sch USING btree (brin);


--
-- Name: lpt_sch_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX lpt_sch_bsn ON lpt_sch USING btree (bsn);


--
-- Name: lpt_vz_brin; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX lpt_vz_brin ON lpt_vz USING btree (brin);


--
-- Name: lpt_vz_bsn; Type: INDEX; Schema: public; Owner: skinkie; Tablespace: 
--

CREATE INDEX lpt_vz_bsn ON lpt_vz USING btree (bsn);


--
-- Name: groepsdossier_bsn_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: skinkie
--

ALTER TABLE ONLY groepsdossier_bsn
    ADD CONSTRAINT groepsdossier_bsn_gid_fkey FOREIGN KEY (gid) REFERENCES groepsdossier(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

