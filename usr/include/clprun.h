
/*
 *  CCC - The Clipper to C++ Compiler
 *  Copyright (C) 2005 ComFirm BT.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#ifndef _CLPRUN_H_
#define _CLPRUN_H_

extern void _clp_main(int argno); 

extern void error_gen(const char *description, const char *operation, VALUE *base, int argno);
extern void error_arg(const char *operation, VALUE *base, int argno);
extern void error_idx(const char *operation, VALUE *base, int argno);
extern void error_arr(const char *operation, VALUE *base, int argno);
extern void error_obj(const char *operation, VALUE *base, int argno);
extern void error_met(const char *operation, VALUE *base, int argno);
extern void error_div(const char *operation, VALUE *base, int argno);
extern void error_neg(const char *operation, VALUE *base, int argno);
extern void error_blk(const char *operation, VALUE *base, int argno);
extern void error_cln(const char *operation, VALUE *base, int argno);
extern void error_nul(const char *operation, VALUE *base, int argno);
extern void error_wcr(const char *operation, VALUE *base, int argno);
extern void error_siz(const char *operation, VALUE *base, int argno);

//File CLPTRACE.CPP:
extern void _clp_procline(int argno); // Clipper kompatibilis
extern void _clp_procname(int argno); // Clipper kompatibilis
extern void _clp_callstack(int argno);
extern void _clp_varstack(int argno);
extern void _clp___varprint(int argno);
extern void var_print(VALUE*);
 
//File CLPARR.CPP:
extern void _clp_array(int argno);
extern void _clp_aadd(int argno); // aadd(a,v)
extern void _clp_asize(int argno); // asize(arr,len)
extern void _clp_ains(int argno); // ains(arr,pos)
extern void _clp_adel(int argno); // adel(arr,pos)
extern void _clp_aclone(int argno); // aclone(arr)
extern void _clp_asort(int argno); // asort(arr,[st],[cn],[blk])

//File CLPSTR.CPP:
extern void _clp_str(int argno);

//File OBJGET.CPP:
extern void _clp_getnew(int argno);

//File CLPTIME.CPP:
extern void _clp_time(int argno);
extern void _clp_seconds(int argno);
extern void _clp_date(int argno);

//File CLPTYPE.CPP:
extern void _clp_valtype(int argno);

//File OBJCOLUM.CPP:
extern void _clp_tbcolumnnew(int argno);

//File CLPSTUFF.CPP:
extern void _clp_stuff(int argno);
extern void _clp_at(int argno);
extern void _clp_rat(int argno);

//File CLPSUBST.CPP:
extern void _clp_substr(int argno);
extern void _clp_left(int argno);
extern void _clp_right(int argno);

//File CLPERR.CPP:
extern void _clp_quitblock(int argno);
extern void _clp_exitblock(int argno);
extern void _clp_errorblock(int argno);
extern void _clp_breakblock(int argno);
extern void _clp_signalblock(int argno);
extern void _clp_ctrlcblock(int argno);
 
//File CLPDKONV.CPP:
extern void _clp___num2dat(int argno);
extern void _clp___dat2num(int argno);
extern void _clp_dtos(int argno);  
extern void _clp_stod(int argno);  

//File OBJBROWS.CPP:
extern void _clp_tbrowsenew(int argno);

//File CLPQOUT.CPP:
extern void _clp__printer(int argno);
extern void _clp__alternate(int argno);
extern void _clp__extra(int argno);
extern void _clp_setconsole(int argno);
extern void _clp_setprinter(int argno);
extern void _clp_setalternate(int argno);
extern void _clp_setextra(int argno);
extern void _clp_qout(int argno);
extern void _clp_qqout(int argno);
extern void _clp_crlf(int argno);
extern void _clp_endofline(int argno);
 
//File CLPALERT.CPP:
extern void _clp_alert(int argno);

//File CLPSYS.CPP:
extern void _clp_exename(int argno);
extern void _clp_getenv(int argno);
extern void _clp_curdir(int argno);

//File CLPEMPTY.CPP:
extern void _clp_empty(int argno);
extern void _clp_len(int argno);

//File CLPTRIM.CPP:
extern void _clp_alltrim(int argno);
extern void _clp_ltrim(int argno);
extern void _clp_rtrim(int argno);
extern void _clp_trim(int argno);

//File CLPPAD.CPP:
extern void _clp_padr(int argno);
extern void _clp_padl(int argno);
extern void _clp_padc(int argno);
extern void _clp_replicate(int argno);
extern void _clp_space(int argno);

//File CLPASC.CPP:
extern void _clp_asc(int argno);
extern void _clp_chr(int argno);
extern void _clp_isalpha(int argno);
extern void _clp_isdigit(int argno);
extern void _clp_isupper(int argno);
extern void _clp_islower(int argno);
extern void _clp_lower(int argno);
extern void _clp_upper(int argno);
extern void _clp_i2bin(int argno);
extern void _clp_bin2i(int argno);
extern void _clp_l2bin(int argno);
extern void _clp_bin2l(int argno);
extern void _clp_f2bin(int argno);
extern void _clp_bin2f(int argno);
extern void _clp_l2hex(int argno);

//File OBJERR.CPP:
extern void _clp_errornew(int argno);

//FIle SYSERROR.PRG:
extern void _clp_ioerrornew(int);
extern void _clp_apperrornew(int);
extern void _clp_eoferrornew(int);
extern void _clp_fnferrornew(int);
extern void _clp_ioerrorclass(int);
extern void _clp_memoerrornew(int);
extern void _clp_readerrornew(int);
extern void _clp_apperrorclass(int);
extern void _clp_eoferrorclass(int);
extern void _clp_fnferrorclass(int);
extern void _clp_writeerrornew(int);
extern void _clp_memoerrorclass(int);
extern void _clp_readerrorclass(int);
extern void _clp_socketerrornew(int);
extern void _clp_tabobjerrornew(int);
extern void _clp_xmltagerrornew(int);
extern void _clp_tranlogerrornew(int);
extern void _clp_writeerrorclass(int);
extern void _clp_socketerrorclass(int);
extern void _clp_tabindexerrornew(int);
extern void _clp_tabobjerrorclass(int);
extern void _clp_xmltagerrorclass(int);
extern void _clp_tabstructerrornew(int);
extern void _clp_tranlogerrorclass(int);
extern void _clp_xmlsyntaxerrornew(int);
extern void _clp_tabindexerrorclass(int);
extern void _clp_tabstructerrorclass(int);
extern void _clp_xmlsyntaxerrorclass(int);
extern void _clp_invalidformaterrornew(int);
extern void _clp_invalidoptionerrornew(int);
extern void _clp_invalidstructerrornew(int);
extern void _clp_invalidformaterrorclass(int);
extern void _clp_invalidoptionerrorclass(int);
extern void _clp_invalidstructerrorclass(int);


//File CLPBREAK.CPP:
extern void _clp_errorlevel(int argno);
extern void _clp_break(int argno);
extern void _clp_break0(int argno);
extern void _clp___quit(int argno);

//File CLPARR1.CPP:
extern void _clp_atail(int argno);
extern void _clp_ascan(int argno);
extern void _clp_aeval(int argno);
extern void _clp_afill(int argno);
extern void _clp_acopy(int argno);
extern void _clp__asort_ascendblock(int argno);

//File CLPEVAL.CPP:
extern void _clp_eval(int argno);

//File CLPARIT.CPP:
extern void _clp_int(int argno);
extern void _clp_abs(int argno);
extern void _clp_round(int argno);
extern void _clp_min(int argno);
extern void _clp_max(int argno);
extern void _clp_exp(int argno);
extern void _clp_log(int argno);
extern void _clp_sqrt(int argno);

//File CLPDIR.CPP:
extern void _clp_directory(int argno);
extern void _clp_file(int argno);

//File CLPSTRAN.CPP:
extern void _clp_strtran(int argno);

//File CLPVAL.CPP:
extern void _clp_val(int argno);

//File CLPSET.CPP:
extern void _clp_set(int argno);
extern void _clp_setprintfile(int argno);
extern void _clp_setaltfile(int argno);
extern void _clp_setextrafile(int argno);
extern void _clp_setcolor(int argno);

//File CLPDATE.CPP:
extern void _clp_day(int argno);
extern void _clp_dow(int argno);
extern void _clp_cdow(int argno);
extern void _clp_month(int argno);
extern void _clp_cmonth(int argno);
extern void _clp_year(int argno);
extern void _clp_ctod(int argno);
extern void _clp_dtoc(int argno);
extern void _clp__date_emptycharvalue(int argno);
extern void _clp__date_templatestring(int argno);

//File CLPSCRN.CPP:
extern void _clp_maxrow(int argno);
extern void _clp_maxcol(int argno);

//File CLPDOUT.CPP:
extern void _clp_devpos(int argno);
extern void _clp_setpos(int argno);
extern void _clp_row(int argno);
extern void _clp_col(int argno);
extern void _clp_devout(int argno); 
extern void _clp_devoutpict(int argno); 

//File CLPTRANS.CPP:
extern void _clp_transform(int argno);
extern char *ParsePicture(VALUE*vp,int*transflags);
extern void trn_string(VALUE *vs,VALUE *vp);
extern void trn_flag(VALUE *vs,VALUE *vp);
extern void trn_date(VALUE *vs,VALUE *vp);
extern void trn_number(VALUE *vs,VALUE *vp);

//File WINAPI.CPP:
extern void _clp_setwindowtext(int argno);
extern void _clp_messagebox(int argno);
extern void _clp_messageloop(int argno);
extern void _clp_paintloop(int argno);
extern void _clp_destroywindow(int argno);
extern void _clp_invalidaterect(int argno);

//File CLPDOUTW.CPP:
extern void _clp_devpos(int argno);
extern void _clp_setpos(int argno);
extern void _clp_row(int argno);
extern void _clp_col(int argno);
extern void _clp_devout(int argno); //ideiglenesen
extern void _clp_createdisplay(int argno);

//File CLPCOLOR.CPP:
extern int  gettext_fg(void);
extern int  gettext_bg(void);
extern void setcoloridx(int idx);
extern void _clp___clr2num(int argno);

//File CLPCONS.CPP:
extern void _clp_maxrow(int argno);
extern void _clp_maxcol(int argno);
extern void _clp_savescreen(int argno);
extern void _clp_restscreen(int argno);
extern void _clp_scroll(int argno);
extern void _clp_inkey(int argno);
extern void _clp___keyboard(int argno);
extern void _clp_setcursor(int argno);
extern void _clp_screeninv(int argno);
extern void _clp_inverserect(int argno);

//File BROWSE0.PRG
extern void _clp__tbrowse_colcount(int argno);
extern void _clp__tbrowse_colpos(int argno);
extern void _clp__tbrowse_rowcount(int argno);
extern void _clp__tbrowse_stable(int argno);
extern void _clp__tbrowse_configure(int argno);
extern void _clp__tbrowse_down(int argno);
extern void _clp__tbrowse_end(int argno);
extern void _clp__tbrowse_gobottom(int argno);
extern void _clp__tbrowse_gotop(int argno);
extern void _clp__tbrowse_home(int argno);
extern void _clp__tbrowse_left(int argno);
extern void _clp__tbrowse_down(int argno);
extern void _clp__tbrowse_pagedown(int argno);
extern void _clp__tbrowse_pageup(int argno);
extern void _clp__tbrowse_panend(int argno);
extern void _clp__tbrowse_panhome(int argno);
extern void _clp__tbrowse_panleft(int argno);
extern void _clp__tbrowse_panright(int argno);
extern void _clp__tbrowse_right(int argno);
extern void _clp__tbrowse_up(int argno);
extern void _clp__tbrowse_addcolumn(int argno);
extern void _clp__tbrowse_colwidth(int argno);
extern void _clp__tbrowse_delcolumn(int argno);
extern void _clp__tbrowse_forcestable(int argno);
extern void _clp__tbrowse_getcolumn(int argno);
extern void _clp__tbrowse_inscolumn(int argno);
extern void _clp__tbrowse_invalidate(int argno);
extern void _clp__tbrowse_refreshall(int argno);
extern void _clp__tbrowse_refreshcurrent(int argno);
extern void _clp__tbrowse_setcolumn(int argno);
extern void _clp__tbrowse_stabilize(int argno);

//File MAINW.CPP:
extern void _clp_create_get_window(int argno);
extern void _clp_create_browse_window(int argno);
extern void _clp_create_display_window(int argno);
extern void _clp_get_display_window(int argno);

//File RCONSOLE.CPP:
extern char *console_type(char *type);
extern char *remote_console();

//File CLPSET.PRG:
extern void _clp___setcentury(int argno);

//File CHARCONV.PRG:
extern int  charconv_char(int tab, int c);
extern void charconv_string(int tab, char *buf, unsigned int len);
extern void charconv_top(int tab);
extern char *charconv_selecttab(int tab);
extern void _clp__charconv(int argno);

//File W32C_KEYB.CPP
extern USHORT GetLockKeyState(USHORT mask);

//File REMINOUT.CPP
extern int ropen(short fp,char *fname,char *mode);
extern int rclose(short fp);
extern int rfputs(short fp,char*txt);
extern int rfwrite(short fp,char*txt,int datalen);

//File FILECONV.CPP
extern int DOSCONV;
extern void _clp_convertfspec2nativeformat(int argno);
extern void convertfspec2nativeformat(VALUE*);

//File SIGNALS.CPP
extern void setup_signal_handlers();

//File UTF8.CPP UTF8CONV.CPP
extern void _clp_utf8len(int argno);
extern void _clp_utf8left(int argno);
extern void _clp_utf8right(int argno);
extern void _clp_utf8substr(int argno);
extern void _clp_utf8chr(int argno);
extern void _clp_ucs(int argno);
extern void _clp_ucsarr_to_utf8(int argno);
extern void _clp_utf8_to_ucsarr(int argno);
extern void _clp_wstr_to_utf8(int argno);
extern void _clp_utf8_to_wstr(int argno);

//File hashcode.cpp
extern unsigned int hashcode(const char *p);

//class.obj:
extern void _clp_classname(int);
extern void _clp_getmethod(int);
extern void _clp___findslot(int);
extern void _clp_classattrib(int);
extern void _clp_classbaseid(int);
extern void _clp_classmethod(int);
extern void _clp_classlistall(int);
extern void _clp___findslot_c(int);
extern void _clp___findslot_p(int);
extern void _clp___findslot_s(int);
extern void _clp___findslot3_c(int);
extern void _clp___findslot3_p(int);
extern void _clp___findslot3_s(int);
extern void _clp_classidbyname(int);
extern void _clp_classregister(int);
extern void _clp_classattrnames(int);
extern void _clp_classmethnames(int);
extern void _clp_classobjectlength(int);
extern void _clp_classinheritstruct(int);

//dispbegin.obj:
extern void _clp_dispend(int);
extern void _clp_dispbegin(int);

//fsetlock.obj:
extern void _clp_funlock(int);
extern void _clp_fsetlock(int);
extern void _clp_fwaitlock(int);
 
#endif

