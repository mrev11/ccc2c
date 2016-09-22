
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

#ifndef _XMETHOD_H_
#define _XMETHOD_H_ 
 
//----------------------------------------------------------------------------
class _method_
{
  private: //protected kellene!

    int  classid;
    void findslot(int clid); //virtual kellene!
    char *slotname;

    VALUE slot;

  public:

    _method_(char *slotname);
    void eval(int argno);
};


//----------------------------------------------------------------------------
class _methods_  //a kompatibilitás érdekében nem örökléssel!
{
  private:

    int  classid;
    void findslot(int clid);
    char *slotname;
    char *basename;

    VALUE slot;

  public:

    _methods_(char *slotname, char *basename);
    void eval(int argno);
};


//----------------------------------------------------------------------------
class _methodc_  //a kompatibilitás érdekében nem örökléssel!
{
  private:

    int  classid;
    void findslot(int clid);
    char *slotname;
    char *basename;
 
    VALUE slot;

  public:

    _methodc_(char *slotname, char *basename);
    void eval(int argno);
};


//----------------------------------------------------------------------------
class _methodp_  //a kompatibilitás érdekében nem örökléssel!
{
  private:

    int  classid;
    void findslot(int clid);
    char *slotname;
    char *prntname;
    char *basename;
 
    VALUE slot;

  public:

    _methodp_(char *slotname, char *prntname, char *basename);
    void eval(int argno);
};
 
//----------------------------------------------------------------------------
#endif


